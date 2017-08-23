
module Mhtml
  LINE_BREAK = "\r\n".freeze
  DOUBLE_LINE_BREAK = "#{LINE_BREAK}#{LINE_BREAK}".freeze
  DUMMY_REQUEST = "GET /on-up HTTP/1.1#{LINE_BREAK}".freeze
end

require 'mhtml/document'
require 'mhtml/http_header'
require 'mhtml/root_document'
require 'mhtml/version'
