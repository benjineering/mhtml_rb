module Mhtml
  class HttpHeader
    attr_reader :key, :values

    # str example:
    # Content-Type: multipart/related; boundary="p00ts"
    def initialize(str)
      raise 'String is nil or empty' if str.nil? || str.strip.empty?

      str.gsub!(/\s+/, ' ')
      str.strip!

      parts = str.match(/\A
        (?<key>.+):\s
        (?<values>.+)
      \Z/x)

      if parts.nil? || parts['key'].nil? || parts['values'].nil?
        raise "Invalid string:\n#{str}"
      end

      @key = parts['key']
      @values = []

      parts['values'].split(';').each do |val_str|
        val_str.strip!
        val = Value.new(val_str)

        if val.nil?
          raise "Invalid value:\n#{val_str}\n\nFrom string:\n#{str}"
        end

        @values << val
      end
    end
    
    class Value
      attr_reader :key, :value

      # str examples:
      # value
      # key="value"
      def initialize(str)
        parts = str.match(/\A
          ((?<key>.+)=)?
          "?(?<value>[^"']+)"?
        \Z/x)

        return nil if parts['value'].nil?

        @key = parts['key'].nil? ? nil : parts['key'].strip
        @value = parts['value'].strip
      end
    end
  end
end
