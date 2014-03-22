# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keysplitter/version'

Gem::Specification.new do |spec|
  spec.name          = "keysplitter"
  spec.version       = Keysplitter::VERSION
  spec.authors       = ["Nick DeMonner", "Nathan Broadbent"]
  spec.email         = ["ndemonner@zenpayroll.com"]
  spec.summary       = %q{Command line tool for Shamir's Secret Sharing}
  spec.description   = %q{Split a secret using Shamir's Secret Sharing, and encrypt / decrypt files with it.}
  spec.homepage      = "zenpayroll.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "commander"
end
