require "bundler/gem_tasks"
require 'rake/extensiontask'
require "rspec/core/rake_task"

spec = Gem::Specification.load('mhtml.gemspec')

Rake::ExtensionTask.new('mhtml_native')

RSpec::Core::RakeTask.new(:spec)

task default: [ :clean, :compile, :spec ]
