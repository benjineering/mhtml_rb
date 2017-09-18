require 'http-parser'
require 'base64'

module Mhtml
  class Document
    attr_reader :chunked, :parser

    attr_accessor :headers, 
      :body, 
      :is_quoted_printable, 
      :is_base_64,
      :encoding, 
      :file_path, 
      :root_doc

    def initialize(str = nil)
      @chunked = !str.is_a?(String)
      @header_key = nil
      @header_value_lines = nil
      @is_quoted_printable = false
      @is_base_64 = false
      @encoding = nil

      @request = HttpParser::Parser.new_instance { |inst| inst.type = :response }

      @parser = HttpParser::Parser.new do |parser|
        parser.on_header_field { |inst, data| handle_header_field(inst, data) }
        parser.on_header_value { |inst, data| handle_header_value(inst, data) }
        parser.on_body { |inst, data| handle_body(inst, data) }
        parser.on_message_begin { |inst| handle_message_begin(inst) }
        parser.on_message_complete { |inst| handle_message_complete(inst) }
      end

      @parser.parse(@request, Mhtml::STATUS_LINE)

      unless @chunked
        @headers = []
        @body = ''
        @parser.parse(@request, str)
      end
    end

    def <<(chunk)
      @parser.parse(@request, chunk)
    end

    def ==(other)
      @headers == other.headers &&
        @body.gsub(/\r\n/, "\n").strip == other.body.gsub(/\r\n/, "\n").strip
    end

    def on_header
      @headers_proc = Proc.new
    end

    def on_body
      @body_proc = Proc.new
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

    def relative_file_path
      return nil if @file_path.nil?
      return '.' if @file_path == @root_doc.file_path

      str = nil

      if !@root_doc.file_path.nil? && @file_path.start_with?(@root_doc.file_path)
        start = @root_doc.file_path.length
        str = @file_path[start..(@file_path.length - 1)]

      elsif @file_path.include?(':')
        start = @file_path.rindex(':') + 1
        str = @file_path[start..(@file_path.length - 1)]

      else
        str = @file_path
      end

      str = str[1..(str.length - 1)] if str[0] == '/'

      str
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
        @body.force_encoding(@encoding) if @body.empty? && !@encoding.nil?
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
          boundary = header.value('boundary')
          @boundary = boundary.value unless boundary.nil?

          charset = header.value('charset')
          
          unless charset.nil?
            @encoding = Encoding.find(charset.value) rescue nil
          end

        elsif header.key == 'Content-Transfer-Encoding'
          value = header.values.first

          if !value.nil?
            if value.value == 'quoted-printable'
              @is_quoted_printable = true            
            elsif value.value == 'base64'
              @is_base_64 = true
            end
          end
        
        elsif header.key == 'Content-Location'
          value = header.values.first
          @file_path = value.value unless value.nil?
        end

        @headers_proc.call(header) unless @headers_proc.nil?

        @header_key = nil
        @header_value_lines = []
      end
    end

    def decode(str)
      str = str.unpack1('M*') if @is_quoted_printable

      if @is_base_64
        begin
          str = Base64.decode64(str)
        rescue Exception => ex
          byebug
        end
      end

      str = str.force_encoding(@encoding) unless @encoding.nil?
      str
    end
  end
end
