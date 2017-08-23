
module Mhtml
  LINE_BREAK = "\r\n".freeze
  DOUBLE_LINE_BREAK = "#{LINE_BREAK}#{LINE_BREAK}".freeze
  STATUS_LINE = "HTTP/1.1 200 OK#{LINE_BREAK}".freeze
end

require 'mhtml/document'
require 'mhtml/http_header'
require 'mhtml/root_document'
require 'mhtml/version'
