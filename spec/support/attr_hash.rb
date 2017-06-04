
class AttrHash
  attr_reader :hsh

  instance_methods(false).each do |method|
    unless method.to_sym == :hsh
      self.hsh[method.to_sym]
    end
  end

  def initialize(hsh)
    @hsh = hsh
    iterate(@hsh)
  end

  def method_missing(method_name, *arguments, &block)
    self.hsh[method_name.to_sym]
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
