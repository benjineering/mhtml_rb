require 'http-parser'

module Mhtml
  class Document
    attr_accessor :headers, :body

    def initialize(str_or_headers_proc, body_proc = nil)
      if str_or_headers_proc.is_a?(String)
        @headers = []

        str = str_or_headers_proc
        body_pos = str.index(Mhtml::DOUBLE_LINE_BREAK)

        header_str = str[0..body_pos].strip
        header_str.gsub!(/\r?\n\s+/, " ") # handle multiline headers

        header_str.split(Mhtml::LINE_BREAK).each do |line|
          @headers << HttpHeader.new(line)       
        end

        @body = str[(body_pos + 1)..(str.length - 1)]

      else
        @headers_proc = str_or_headers_proc
        @body_proc = body_proc
      end
    end

    def <<(chunk)
      
    end

    def ==(other)
      @headers == other.headers && @body == other.body
    end

    # for testing only = no spec implemented
    def to_s
      @headers.join(LINE_BREAK) + Mhtml::DOUBLE_LINE_BREAK + @body
    end
  end
end
