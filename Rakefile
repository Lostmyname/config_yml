$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require "bundler/gem_tasks"
require "configuration/tasks"

task :default => :spec

desc "Run unit tests"
task :spec do
  ruby "-S rspec"
end
