module Mhtml
  class Header
    require 'string'

    attr_reader :http_headers, :boundary, :body

    # str example:
    # MIME-Version: 1.0
    # Content-Type: multipart/related; boundary="----=_NextPart_01C74319.B7EA56A0"
    # 
    # This document is a Single File Web Page, also known as a Web Archive \
    # file.  If you are seeing this message, your browser or editor doesn't \
    # support Web Archive files.  Please download a browser that supports Web \
    # Archive, such as Microsoft Internet Explorer.
    def initialize(str)
      raise 'String is nil or empty' if str.nil? || str.strip.empty?

      str.strip!
      parts = str.split("#{LINE_BREAK}#{LINE_BREAK}")

      @body = parts[1].strip if parts.length > 1
      @http_headers = []

      prev_index = 0
      parts.first.each_index(/#{LINE_BREAK}[^\t ]/) do |i|
        head_str = parts.first[prev_index, i].strip
        add_header(head_str)
        prev_index = i
      end

      head_str = parts.first[prev_index, parts.first.length - 1].strip
      add_header(head_str)
    end

    private

    def add_header(str)
      unless str.empty?
        header = HttpHeader.new(str)
        @http_headers << header

        if header.key == 'Content-Type'
          header.values.each do |value|
            if !value.key.nil? && value.key.downcase == 'boundary'
              @boundary = value.value.strip_other('--')
            end
          end
        end
      end
    end

  end
end
