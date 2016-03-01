# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mapping/version'

Gem::Specification.new do |spec|
	spec.name          = "mapping"
	spec.version       = Mapping::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = %q{Map an input model to an output model using a mapping model.}
	spec.description   = %q{Map model objects based on their class to a given output model. Useful for versioning external interfaces (e.g. JSON APIs) or processing structured data from one format to another.}
	spec.homepage      = "https://github.com/ioquatix/mapping"

	spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
	spec.bindir        = "exe"
	spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	spec.add_development_dependency "bundler", "~> 1.11"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
end
