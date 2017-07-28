class Fixture
  require 'yaml'

  FIXTURES_ROOT = "#{__dir__}/fixtures"

  DEFAULT_CHUNK_SIZE = 256

  attr_reader :yaml, :instance, :data

  def initialize(klass)
    class_name = klass.name.split('::').last.underscore
    filename = "#{class_name}_fixture.yml"
    path = "#{FIXTURES_ROOT}/#{filename}"
    yaml = YAML.load_file(path)
    
    @data = yaml[class_name].attr_hash
    @yaml = yaml.attr_hash
    @instance = klass.new(@yaml.raw)
  end

  def method_missing(method_name, *arguments, &block)
    @data.hsh[method_name.to_s]
  end

  # Requires a block
  # Yields chunked data of maximum size as per parameter
  def chunks(chunk_size = DEFAULT_CHUNK_SIZE)
    raise 'Block required' unless block_given?

    range_end = lambda do |max|
      val = max > @yaml.raw.length ? @yaml.raw.length : max
      val - 1
    end

    range = 0..range_end.call(chunk_size)

    loop do
      yield @yaml.raw[range]
      break if range.last + 1 == @yaml.raw.length
      first = range.last + 1
      last = range_end.call(range.last + chunk_size)
      range = first..last
    end
  end
end
