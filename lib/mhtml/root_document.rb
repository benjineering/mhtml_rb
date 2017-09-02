module Mhtml
  class RootDocument < Document
    BOUNDARY_PREFIX = '--'.freeze

    attr_accessor :boundary, :sub_docs


    def initialize(str_or_headers_proc, body_proc = nil, subdocs_proc = nil)
      @subdoc = nil

      if @chunked
        @subdocs_proc = subdocs_proc 
      else
        @subdocs = []
      end

      super(str_or_headers_proc, body_proc)
    end

    def ==(other)
      super(other) && @boundary == other.boundary && @sub_docs == other.sub_docs
    end

    def boundary_str
      "#{Mhtml::DOUBLE_LINE_BREAK}#{BOUNDARY_PREFIX}#{@boundary}"\
      "#{Mhtml::LINE_BREAK}"
    end

    def handle_body(inst, data)
      parts = super(inst, data)

      if @body_read || parts.length > 1
        if @body_read
          @subdoc << data
        else
          parts[1, parts.length - 2].each do |part|
            @subdoc << part
          end
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

    def create_subdoc
      @subdoc = Document.new(
        -> header { handle_subdoc_header(header) },
        -> body { handle_subdoc_body(body) }
      )
    end

    def handle_subdoc_header(header)
      create_subdoc if @subdoc.nil?

      if @chunked
        @subdoc.headers_proc.call(header)
      else
        @subdoc.headers << header
      end
    end

    def handle_subdoc_body(body)
      create_subdoc if @subdoc.nil?

      if @chunked
        @subdoc.body_proc.call(body)
      else
        @subdoc.body += body
      end
    end

    def handle_message_complete(inst)
      super(inst)
      
      unless @subdoc.nil?
        @subdocs_proc.call(@subdoc)
        @subdoc = nil
      end
    end
  end
end
