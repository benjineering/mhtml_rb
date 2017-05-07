
class AttrHash
  attr_reader :hsh

  instance_methods(false).each do |method|
    unless method.to_sym == :hsh
      self.hsh[method.to_sym]
    end
  end

  def initialize(hsh)
    @hsh = hsh
  end

  def method_missing(method_name, *arguments, &block)
    self.hsh[method_name.to_sym]
  end
end


class Hash
  def attr_hash
    AttrHash.new(self)
  end
end
