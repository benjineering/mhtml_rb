
class AttrHash
  attr_reader :hsh

  def initialize(hsh)
    @hsh = hsh  
    iterate(@hsh)
  end

  def method_missing(method_name, *arguments, &block)
    val = @hsh[method_name]
    val = @hsh[method_name.to_s] if val.nil?
    val
  end

  private

  def iterate(enum)
    if enum.is_a?(Array)
      enum.each_with_index do |v, i|
        enum[i] = AttrHash.new(v) if v.is_a?(Hash)
        iterate(v) if v.respond_to?(:each)
      end

    elsif enum.is_a?(Hash)
      enum.each do |k, v|
        enum[k] = AttrHash.new(v) if v.is_a?(Hash)
        iterate(v) if v.respond_to?(:each)
      end

    else
      raise TypeError, 'Parameter must be an Array or Hash'
    end
  end
end


class Hash
  def attr_hash
    AttrHash.new(self)
  end
end
