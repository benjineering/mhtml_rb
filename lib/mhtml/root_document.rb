module Mhtml
  class RootDocument < Document
    
    attr_accessor :boundary, :sub_docs

    BOUNDARY_PREFIX = '--'.freeze

    def initialize(str_or_headers_proc, body_proc = nil, subdocs_proc = nil)
      if @chunked
        @subdocs_proc = subdocs_proc 
      else
        @subdocs = []
      end

      @subdoc = nil

      super(str_or_headers_proc, body_proc)
    end

    def ==(other)
      super(other) && @boundary == other.boundary && @sub_docs == other.sub_docs
    end

    def boundary_str
      "#{Mhtml::DOUBLE_LINE_BREAK}#{BOUNDARY_PREFIX}#{@boundary}\
#{Mhtml::LINE_BREAK}"
    end

    def handle_body(inst, data)
      parts = super(inst, data)

      # TODO: handle subdocs
      if @body_read || parts.length > 1
        if @subdoc.nil?
          @subdoc = Document.new()
        end
      end
    end

    # for testing only = no spec implemented
    def to_s
      doc_sep = Mhtml::DOUBLE_LINE_BREAK + BOUNDARY_PREFIX + @boundary + 
        Mhtml::LINE_BREAK
      super + doc_sep + @sub_docs.join(doc_sep)
    end

    private

    def handle_subdoc_header(header)
      if @chunked
        
      else

      end
    end

    def handle_subdoc_body(str)

    end
  end
end
