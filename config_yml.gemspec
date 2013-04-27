$:.unshift(File.expand_path("../lib", __FILE__))
require "configuration/version"

Gem::Specification.new do |spec|
  spec.name        = "config_yml"
  spec.version     = Configuration::VERSION.dup
  spec.summary     = "Simplify your app configuration."
  spec.description = "A very simple way of configure your ruby applications through yaml files."
  spec.license     = "MIT"

  spec.authors     = ["Vitor Kiyoshi Arimitsu"]
  spec.email       = "to@vitork.com"
  spec.homepage    = "https://github.com/vitork/config_yml"

  spec.files       = `git ls-files`.split("\n")
  spec.test_files  = `git ls-files -- spec/*`.split("\n")
end
