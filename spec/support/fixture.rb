class Fixture
  require 'yaml'

  FIXTURES_ROOT = "#{File.expand_path(File.dirname(__FILE__))}/fixtures"

  attr_reader :yaml

  def initialize(klass)
    class_name = klass.name.split('::').last.underscore
    filename = "#{class_name}_fixture.yml"
    path = "#{FIXTURES_ROOT}/#{filename}"
    @yaml = YAML.load_file(path).attr_hash
  end

  def method_missing(method_name, *arguments, &block)
    @yaml[method_name.to_sym]
  end
end
