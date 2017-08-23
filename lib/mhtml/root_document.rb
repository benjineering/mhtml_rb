module Mhtml
  class RootDocument < Document
    
    attr_accessor :boundary, :sub_docs

    BOUNDARY_PREFIX = '--'.freeze

    def initialize(str_or_headers_proc, body_proc = nil, subdocs_proc = nil)
      
    end

    def <<(chunk)
      #TODO
    end

    def ==(other)
      super(other) && @boundary == other.boundary && @sub_docs == other.sub_docs
    end

    # for testing only = no spec implemented
    def to_s
      doc_sep = Mhtml::DOUBLE_LINE_BREAK + BOUNDARY_PREFIX + @boundary + 
        Mhtml::LINE_BREAK
      super + doc_sep + @sub_docs.join(doc_sep)
    end
  end
end
