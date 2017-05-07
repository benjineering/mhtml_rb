module Mhtml
  class Header
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

      parts = str.match(/\A
        (?<http_headers>.+)
        #{LINE_BREAK}#{LINE_BREAK}
        (?<body>.+)?
      \Z/x)

      raise "Invalid string:\n#{str}" if parts.nil? || parts['http_headers'].nil?

      @body = parts['body'].nil? ? nil : parts['body'].strip
      @http_headers = []

      parts['http_headers'].split(/#{LINE_BREAK}[^\t ]/).each do |head_str|

      end
    end
  end
end
