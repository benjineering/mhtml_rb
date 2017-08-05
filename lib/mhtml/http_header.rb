module Mhtml
  class HttpHeader
    require 'string'

    attr_accessor :key, :values

    KEY_VALUE_SEP = ':'.freeze
    VALUE_SEP = ';'.freeze

    def initialize(str)
      raise 'String is nil or empty' if str.nil? || str.strip.empty?

      str.gsub!(/\s+/, ' ')
      str.strip!

      parts = str.match(/\A
        (?<key>.+)#{KEY_VALUE_SEP}\s
        (?<values>.+)
      \Z/x)

      if parts.nil? || parts['key'].nil? || parts['values'].nil?
        raise "Invalid string:\n#{str}"
      end

      @key = parts['key']
      @values = []

      parts['values'].split(VALUE_SEP).each do |val_str|
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

      # for testing only = no spec implemented
      def to_s
        "#{@key}#{KEY_VALUE_SEP} #{@values.join(VALUE_SEP + ' ')}"
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

      # for testing only = no spec implemented
      def to_s
        if @key.nil?
          @value
        else
          %Q(#{@key}="#{@value}")
        end
      end
    end
  end
end
