require 'attr_hash'
require 'bundler/setup'
require 'mhtml'
require 'string'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
