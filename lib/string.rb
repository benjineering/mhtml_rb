class String
  
  def each_index(x)
    raise 'Block required' unless block_given?
    return if empty? || x.nil?

    i = 0
    while true
      i = index(x, i)
      return if i.nil?

      yield i
      i += 1

      return if i + 1 == length
    end
  end

  def strip_other(str)
    start_i = 0
    new_length = length

    if start_with?(str)
      start_i += str.length
      new_length -= str.length
    end

    if end_with?(str)
      new_length -= str.length
    end

    self[start_i, new_length]
  end

  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def index_of_split(other)
    last_idx = (other.length - 1)

    (0..last_idx).step do |i|
      part = other[i..last_idx]      
      return part.length - 1 if start_with?(part)
    end

    nil
  end

  def rindex_of_split(other)
    last_idx = (other.length - 1)

    (0..last_idx).step do |i|
      part = other[0..(last_idx - i)]
      return length - part.length if end_with?(part)
    end

    nil
  end
end
