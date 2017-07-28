module Mhtml
  class RootDocument < Document
    
    attr_reader :boundary, :sub_docs

    def initialize(str_or_headers_proc, body_proc = nil, subdocs_proc = nil)

    end

    def <<(chunk)

    end
  end
end
