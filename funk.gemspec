# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'funk/version'

Gem::Specification.new do |spec|
  spec.name          = "funk-rb"
  spec.version       = Funk::VERSION
  spec.authors       = ["Tony Schneider", "John Andrews"]
  spec.email         = ["tonywok@gmail.com", "john.m.andrews@gmail.com"]

  spec.summary       = %q{Structured computation graphs for ruby!}
  spec.homepage      = "https://github.com/tonywok/funk"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
end
