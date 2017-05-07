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
end
