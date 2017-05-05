module Mhtml
  class Document
    attr_reader :header, :sub_docs

    def initialize
      @header = Header.new
      @sub_docs = []
    end
  end
end
