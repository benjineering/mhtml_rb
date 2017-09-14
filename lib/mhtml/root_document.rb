module Mhtml
  class RootDocument < Document
    BOUNDARY_PREFIX = '--'.freeze

    attr_accessor :boundary, :sub_docs

    def initialize(str = nil)
      super(str)
      @sub_doc = nil
      @sub_docs = []
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
      "#{Mhtml::DOUBLE_LINE_BREAK}#{BOUNDARY_PREFIX}#{@boundary}"\
      "#{Mhtml::LINE_BREAK}"
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

      if @body_read
        parts.each do |part|          
          create_subdoc if @sub_doc.nil?
          
        end
      end
    end

    def create_subdoc
      @sub_doc = Document.new
      @sub_doc.on_subdoc_header { handle_subdoc_header(header) }
      @sub_doc.on_subdoc_body { handle_subdoc_body(body) }
    end

    def handle_subdoc_header(header)
      if @chunked
        @sub_doc.headers_proc.call(header)
      else
        @sub_doc.headers << header
      end
    end

    def handle_subdoc_body(body)
      create_subdoc if @sub_doc.nil?

      if @chunked
        @sub_doc.body_proc.call(body)
      else
        @sub_doc.body += body
      end
    end

    def handle_message_complete(inst)
      super(inst)
      
      unless @sub_doc.nil?
        @subdocs_proc.call(@sub_doc)
        @sub_doc = nil
      end
    end
  end
end
