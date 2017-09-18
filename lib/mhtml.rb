
module Mhtml

  LINE_BREAK = "\r\n".freeze
  DOUBLE_LINE_BREAK = "#{LINE_BREAK}#{LINE_BREAK}".freeze

  STATUS_LINE = "HTTP/1.1 200 OK#{LINE_BREAK}".freeze

  FILE_EXTENSIONS = [ '.mht', '.mhtml' ].freeze

  def self.is_mhtml(filename)
    ext = File.extname(filename)
    return false if ext.empty?
    ext.downcase!
    FILE_EXTENSIONS.include?(ext)
  end
end

require 'mhtml/document'
require 'mhtml/http_header'
require 'mhtml/root_document'
require 'mhtml/version'
