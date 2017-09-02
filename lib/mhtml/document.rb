require 'http-parser'

module Mhtml
  class Document
    attr_accessor :chunked
    attr_reader :headers, :body

    def initialize(str_or_headers_proc, body_proc = nil)
      @chunked = !str_or_headers_proc.is_a?(String)
      @header_key = nil
      @header_value_lines = nil

      @request = HttpParser::Parser.new_instance { |inst| inst.type = :response }

      @parser = HttpParser::Parser.new do |parser|
        parser.on_header_field { |inst, data| handle_header_field(inst, data) }
        parser.on_header_value { |inst, data| handle_header_value(inst, data) }
        parser.on_body { |inst, data| handle_body(inst, data) }
        parser.on_message_begin { |inst| handle_message_begin(inst) }
        parser.on_message_complete { |inst| handle_message_complete(inst) }
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

    def encoding
      h = header('Content-Type')
      return nil if h.nil?

      v = h.value('charset')
      return nil if v.nil?

      begin
        return Encoding.find(v.value)
      rescue ArgumentError => ex
      end

      nil
    end

    def quoted_printable?
      h = header('Content-Transfer-Encoding')
      return false if h.nil?

      v = h.values.first
      return false if v.nil?

      v.value == 'quoted-printable'
    end

    def header(key)
      header = nil

      @headers.each do |h|
        if h.key == key
          header = h
          break
        end
      end

      header
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
      maybe_create_header
      decoded = decode(data)

      if @chunked
        @body_proc.call(decoded) unless @body_proc.nil?
      else
        @body += decoded
      end
    end

    def handle_message_begin(inst)
    end

    def handle_message_complete(inst)
    end

    def maybe_create_header
      unless @header_key.nil?
        header = HttpHeader.new(@header_key, @header_value_lines)
        @headers << header unless @chunked

        if header.key == 'Content-Type'
          bound_header = header.value('boundary')
          @boundary = bound_header.value unless bound_header.nil?
        end

        @headers_proc.call(header) unless @headers_proc.nil?

        @header_key = nil
        @header_value_lines = []
      end
    end

    def decode(str)
      str = str.unpack1('M*') if quoted_printable?

      enc = encoding
      str = str.force_encoding(enc) unless enc.nil?

      str
    end
  end
end
