# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poly_pseudo/version'

Gem::Specification.new do |spec|
  spec.name          = "poly_pseudo"
  spec.version       = PolyPseudo::VERSION
  spec.authors       = ["Benoist Claassen"]
  spec.email         = ["bclaassen@digidentity.eu"]

  spec.summary       = %q{Gem to decrypt polymorphic pseudonyms and identities}
  spec.description   = %q{Gem to decrypt polymorphic pseudonyms and identities}
  spec.homepage      = "https://www.digidentity.eu"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"

  spec.add_dependency "ffi", "~> 1.9"
end
