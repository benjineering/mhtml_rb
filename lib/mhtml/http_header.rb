module Mhtml
  class HttpHeader
    require 'string'

    attr_accessor :key, :values

    KEY_VALUE_SEP = ':'.freeze
    VALUE_SEP = ';'.freeze

    def initialize(key_or_hash, value_lines = nil)
      if key_or_hash.is_a?(Hash)
        @key = key_or_hash[:key]
        @values = key_or_hash[:values]
        return
      end

      @key = key_or_hash
      @values = []
      values_str = value_lines.join('')

      values_str.split(VALUE_SEP).each do |val_str|
        val_str.strip!
        val = Value.new(val_str)

        if val.nil?
          raise "Invalid value:\n#{val_str}\n\nFrom string:\n#{val_str}"
        end

        @values << val
      end
    end

    def ==(other)
      @key == other.key && @values == other.values
    end

    def value(key)
      value = nil

      @values.each do |v|
        if v.key == key
          value = v
          break
        end
      end

      value
    end

    # following methods are for debugging only - no spec implemented
    def to_s
      "#{@key}#{KEY_VALUE_SEP} #{@values.join(VALUE_SEP + ' ')}"
    end

    def clone
      vals = @values.collect { |v| v.clone }
      HttpHeader.new(key: @key.clone, values: vals)
    end

    class Value
      attr_reader :key, :value

      # str examples:
      # value
      # key="value"
      def initialize(str_or_hash)
        if str_or_hash.is_a?(Hash)
          @key = str_or_hash[:key]
          @value = str_or_hash[:value]
          return
        end

        str = str_or_hash
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
        @key == other.key && @value == other.value
      end

      # following methods are for debugging only - no spec implemented
      def to_s
        if @key.nil?
          @value
        else
          %Q[#{@key}="#{@value}"]
        end
      end

      def clone
        Value.new(key: @key.clone, value: @value.clone)
      end
    end
  end
end
