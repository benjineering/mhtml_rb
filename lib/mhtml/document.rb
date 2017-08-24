require 'http-parser'

module Mhtml
  class Document
    attr_accessor :headers, :body, :chunked

    def initialize(str_or_headers_proc, body_proc = nil)
      @chunked = !str_or_headers_proc.is_a?(String)
      @header_key = nil
      @header_value_lines = nil
      @body_read = false

      @request = HttpParser::Parser.new_instance { |inst| inst.type = :response }

      @parser = HttpParser::Parser.new do |parser|
        parser.on_header_field do |inst, data|
          handle_header_field(inst, data)
        end

        parser.on_header_value do |inst, data|
          handle_header_value(inst, data)
        end

        parser.on_body do |inst, data|
          handle_body(inst, data)
        end
      end

      @parser.parse(@request, Mhtml::STATUS_LINE)

      if @chunked
        @headers_proc = str_or_headers_proc
        @body_proc = body_proc
      else
        @headers = []
        @body = ''
        @parser.parse(@request, str_or_headers_proc)
      end
    end

    def <<(chunk)
      @parser.parse(@request, chunk)
    end

    def ==(other)
      @headers == other.headers && @body == other.body
    end

    # for testing only = no spec implemented
    def to_s
      @headers.join(LINE_BREAK) + Mhtml::DOUBLE_LINE_BREAK + @body
    end

    private

    def handle_header_field(inst, data)
      maybe_create_header
      @header_key = data
      @header_value_lines = []
    end

    def handle_header_value(inst, data)
      @header_value_lines << data
    end

    def handle_body(inst, data)
      parts = data.split(boundary_str)

      unless @body_read
        maybe_create_header

        if @chunked
          @body_proc.call(parts.first) unless @body_proc.nil?
        else
          @body += parts.first
        end

        @body_read = data.include?(Mhtml::LINE_BREAK)
      end

      return parts
    end

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
