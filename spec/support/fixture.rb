class Fixture

  FIXTURES_ROOT = "#{File.expand_path(File.dirname(__FILE__))}/fixtures"

  attr_reader :klass

  def initialize(class_name)
    filename = "#{class_name.to_s.underscore}.yml"
    path = "#{FIXTURES_ROOT}/#{filename}"
    raise ArgumentError, "#{filename} not found" unless File.file?(path)

    # TODO: create objects
  end
end
