# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nod_webshop/version'

Gem::Specification.new do |spec|
  spec.name          = "nod_webshop"
  spec.version       = NodWebshop::VERSION
  spec.authors       = ["Aurel Canciu"]
  spec.email         = ["aurelcanciu@gmail.com"]
  spec.description   = %q{nod.ro b2b API wrapper gem}
  spec.summary       = %q{nod.ro b2b API wrapper gem}
  spec.homepage      = "https://github.com/relu/nod_webshop"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "addressable"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
