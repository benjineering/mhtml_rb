module Mhtml
  class HttpHeader
    attr_reader :key, :values

    # str example:
    # Content-Type: multipart/related; boundary="p00ts"
    def initialize(str)
      
    end
    
    # Either:
    #   "value" -or-
    #   "key=value"
    class Value
      attr_reader :key, :value

    end
  end
end
