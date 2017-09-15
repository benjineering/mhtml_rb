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
      parts = data.split(boundary_str)
      
      unless @body_read
        @body_read = parts.length > 1
        super(inst, parts.shift)
      end

      parts.each_with_index do |part, i|
        end_boundary_pos = part.index(last_boundary_str)
        is_last = !end_boundary_pos.nil?
        part = part[0..(end_boundary_pos - 1)] if is_last

        if @chunked

          #@sub_doc = create_chunked_subdoc

        else
          @sub_docs << Document.new(part)
        end
      end
    end

    def create_chunked_subdoc
      @sub_doc = Document.new

      #@sub_doc.parser.on_message_begin { }

      @sub_doc.on_header do |header| 
        if @chunked
          @subdoc_header_proc.call(header) unless @subdoc_header_proc.nil?
        else
          @sub_doc.headers << header
        end
      end

      @sub_doc.on_body do |body|
        if @chunked
          @subdoc_body_proc.call(body) unless @subdoc_body_proc.nil?
        else
          @sub_doc.body += body
        end
      end

      #@sub_doc.parser.on_message_complete { }
    end
  end
end
