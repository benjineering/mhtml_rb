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

    end
  end
end
