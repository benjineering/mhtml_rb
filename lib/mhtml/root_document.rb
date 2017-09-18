module Mhtml
  class RootDocument < Document
    BOUNDARY_PREFIX = '--'.freeze

    attr_accessor :boundary, :sub_docs

    def initialize(str = nil)
      @sub_docs = []
      super(str)
    end

    def ==(other)
      super(other) && @boundary == other.boundary && @sub_docs == other.sub_docs
    end

    def on_subdoc_begin
      @subdoc_begin_proc = Proc.new
    end

    def on_subdoc_header
      @subdoc_header_proc = Proc.new
    end

    def on_subdoc_body
      @subdoc_body_proc = Proc.new
    end

    def on_subdoc_complete
      @subdoc_complete_proc = Proc.new
    end

    def boundary_str
      "#{Mhtml::LINE_BREAK}#{BOUNDARY_PREFIX}#{@boundary}#{Mhtml::LINE_BREAK}"
    end

    def last_boundary_str
      "#{Mhtml::LINE_BREAK}#{BOUNDARY_PREFIX}#{@boundary}#{BOUNDARY_PREFIX}#{Mhtml::LINE_BREAK}"
    end

    # for testing only = no spec implemented
    def to_s
      doc_sep = Mhtml::DOUBLE_LINE_BREAK + BOUNDARY_PREFIX + @boundary + 
        Mhtml::LINE_BREAK
      super + doc_sep + @sub_docs.join(doc_sep)
    end

    private

    def handle_body(inst, data)
      maybe_create_header
      boundary = boundary_str

      unless @split.nil?
        data = @split + data
        @split = nil
      end

      parts = data.split(boundary)
      
      unless @body_read
        @body_read = parts.length > 1
        super(inst, parts.shift)
      end

      parts.each_with_index do |part, i|
        end_boundary_pos = part.rindex(last_boundary_str)
        is_last_subdoc = !end_boundary_pos.nil?
        part = part[0..(end_boundary_pos - 1)] if is_last_subdoc

        if @chunked
          is_last_part = i + 1 == parts.length
          handle_chunked_body(part, is_last_part, is_last_subdoc)
        else
          sub_doc = Document.new(part)
          sub_doc.root_doc = self
          @sub_docs << sub_doc
        end
      end
    end

    def handle_chunked_body(chunk, is_last_part, is_last_subdoc)
      if @chunked_sub_doc.nil?
        create_chunked_subdoc
        @subdoc_begin_proc.call unless @subdoc_begin_proc.nil?
      end

      if is_last_part
        split_idx = chunk.rindex_of_split(boundary_str)

        if split_idx.nil?
          quoted_matches = chunk.match(/=[0-9A-F\r\n]{0,2}\Z/)

          unless quoted_matches.nil?
            split_idx = chunk.length - quoted_matches[0].length + 1
          end              
        end

        unless split_idx.nil?
          @split = chunk[split_idx..(chunk.length - 1)]
          chunk = chunk[0..(split_idx - 1)]
        end
      end

      @chunked_sub_doc << chunk

      unless is_last_part && !is_last_subdoc
        @sub_docs << @chunked_sub_doc
        @chunked_sub_doc = nil
        @subdoc_complete_proc.call unless @subdoc_complete_proc.nil?
      end
    end

    def create_chunked_subdoc
      @chunked_sub_doc = Document.new
      @chunked_sub_doc.root_doc = self

      @chunked_sub_doc.on_header do |header| 
        @subdoc_header_proc.call(header) unless @subdoc_header_proc.nil?
      end

      @chunked_sub_doc.on_body do |body|
        @subdoc_body_proc.call(body) unless @subdoc_body_proc.nil?
      end
    end
  end
end
