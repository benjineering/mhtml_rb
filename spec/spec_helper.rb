require 'bundler/setup'
require 'byebug'
require 'mhtml'
require 'string'

SPEC_DIR = File.expand_path(File.dirname(__FILE__))

Dir["#{SPEC_DIR}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
