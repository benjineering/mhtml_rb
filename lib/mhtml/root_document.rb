module Mhtml
  class RootDocument < Document
    
    attr_accessor :boundary, :sub_docs

    def initialize(str_or_headers_proc, body_proc = nil, subdocs_proc = nil)
      #TODO
    end

    def <<(chunk)
      #TODO
    end

    def ==(other)
      super(other) && @boundary == other.boundary && @sub_docs == other.sub_docs
    end
  end
end
