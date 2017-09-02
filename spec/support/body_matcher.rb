require 'rspec/expectations'

RSpec::Matchers.define :eq_body do |expected|
  match do |actual|
    expected.gsub(/\r\n/, "\n") == actual.gsub(/\r\n/, "\n")
  end
end
