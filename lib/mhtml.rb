
module Mhtml
  LINE_BREAK = "\r\n"
  DOUBLE_LINE_BREAK = "#{LINE_BREAK}#{LINE_BREAK}"
end

require 'mhtml/document'
require 'mhtml/http_header'
require 'mhtml/root_document'
require 'mhtml/version'
