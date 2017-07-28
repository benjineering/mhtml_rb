class Fixture
  require 'yaml'

  FIXTURES_ROOT = "#{__dir__}/fixtures"

  DEFAULT_CHUNK_SIZE = 256

  attr_reader :yaml, :data, :klass

  def initialize(klass)
    @klass = klass
    class_name = @klass.name.split('::').last.underscore
    filename = "#{class_name}_fixture.yml"
    path = "#{FIXTURES_ROOT}/#{filename}"
    yaml = YAML.load_file(path)
    
    @data = yaml[class_name].attr_hash
    @yaml = yaml.attr_hash
  end

  def method_missing(method_name, *arguments, &block)
    @data.hsh[method_name.to_s]
  end

  def source_file
    File.open("#{__dir__}/fixtures/#{yaml.source}")
  end

  def instance
    @klass.new(source_file.read)
  end

  # Requires a block
  # Yields chunked data of maximum size as per parameter
  def chunks(chunk_size = DEFAULT_CHUNK_SIZE)
    raise 'Block required' unless block_given?

    raw = source_file.read

    range_end = lambda do |max|
      val = max > raw.length ? raw.length : max
      val - 1
    end

    range = 0..range_end.call(chunk_size)

    loop do
      yield raw[range]
      break if range.last + 1 == raw.length
      first = range.last + 1
      last = range_end.call(range.last + chunk_size)
      range = first..last
    end
  end
end
