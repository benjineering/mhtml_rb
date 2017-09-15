lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mhtml/version'

Gem::Specification.new do |spec|
  spec.name          = 'mhtml'
  spec.version       = Mhtml::VERSION
  spec.authors       = [ 'Ben Williams' ]
  spec.email         = [ '8enwilliams@gmail.com' ]

  spec.summary       = 'A Ruby gem for reading and extracting MHTML files'
  spec.description   = 'A Ruby gem for reading and extracting MHTML files'
  spec.homepage      = 'https://github.com/benjineering/mhtml_rb'
  spec.licenses      = [ 'MIT', 'GPL-2' ]

  spec.metadata[ 'allowed_push_host' ] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = [ 'lib' ]

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug'

  spec.add_dependency 'http-parser'
end
