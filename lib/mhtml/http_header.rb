module Mhtml
  class HttpHeader
    require 'string'

    attr_reader :key, :values

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

      def ==(other)
        self.class == other.class && @key = other.key && @values == other.values
      end
    end
    
    class Value
      attr_reader :key, :value

      # str examples:
      # value
      # key="value"
      def initialize(str)
        split_i = str.index('=')
        @key = str[0, split_i].strip unless split_i.nil?

        @value = 
        if split_i.nil?
          str.strip
        else
          str[split_i + 1, str.length - 1].strip.strip_other('"')
        end
      end

      def ==(other)
        self.class == other.class && @key == other.key && @value == other.value
      end
    end
  end
end
