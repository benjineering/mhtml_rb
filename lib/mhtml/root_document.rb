module Mhtml
  class RootDocument < Document
    
    attr_accessor :boundary, :sub_docs

    BOUNDARY_PREFIX = '--'.freeze

    def initialize(str_or_headers_proc, body_proc = nil, subdocs_proc = nil)
      @chunked = !str_or_headers_proc.is_a?(String)
      @header_key = nil
      @header_value_lines = nil
      @body_read = false

      @request = HttpParser::Parser.new_instance { |inst| inst.type = :response }

      @parser = HttpParser::Parser.new do |parser|
        parser.on_header_field do |inst, data|
          maybe_create_header
          @header_key = data
          @header_value_lines = []
        end

        parser.on_header_value do |inst, data|
          @header_value_lines << data
        end

        parser.on_body do |inst, data|
          unless @body_read
            maybe_create_header
            parts = data.split(boundary_str)

            if @chunked
              @body_proc.call(parts.first) unless @body_proc.nil?
            else
              @body += parts.first
            end

            @body_read = data.include?(Mhtml::LINE_BREAK)
          end

          # TODO: handle subdocs
        end
      end

      @parser.parse(@request, Mhtml::STATUS_LINE)

      if @chunked
        @headers_proc = str_or_headers_proc
        @body_proc = body_proc
        @subdocs_proc = subdocs_proc
      else
        @headers = []
        @subdocs = []
        @body = ''

        @parser.parse(@request, str_or_headers_proc)
      end
    end

    def <<(chunk)
      @parser.parse(@request, chunk)
    end

    def ==(other)
      super(other) && @boundary == other.boundary && @sub_docs == other.sub_docs
    end

    def boundary_str
      "#{Mhtml::DOUBLE_LINE_BREAK}#{BOUNDARY_PREFIX}#{@boundary}\
#{Mhtml::LINE_BREAK}"
    end

    # for testing only = no spec implemented
    def to_s
      doc_sep = Mhtml::DOUBLE_LINE_BREAK + BOUNDARY_PREFIX + @boundary + 
        Mhtml::LINE_BREAK
      super + doc_sep + @sub_docs.join(doc_sep)
    end

    private

    def maybe_create_header
      unless @header_key.nil?
        header = HttpHeader.new(@header_key, @header_value_lines)
        @headers << header unless @chunked

        if header.key == 'Content-Type'
          b_header = header.values.select { |v| v.key == 'boundary' }.first
          @boundary = b_header.value unless b_header.nil?
        end

        @headers_proc.call(header) unless @headers_proc.nil?

        @header_key = nil
        @header_value_lines = []
      end
    end
  end
end
