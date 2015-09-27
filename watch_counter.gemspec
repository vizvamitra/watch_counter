# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'watch_counter/version'

Gem::Specification.new do |spec|
  spec.name          = "watch_counter"
  spec.version       = WatchCounter::VERSION
  spec.authors       = ["Dmitrii Krasnov"]
  spec.email         = ["vizvamitra@gmail.com"]

  spec.summary       = %q{service for counting active video watches}
  spec.description   = %q{can register watches and answer questions like "How many videos this customer watches now?" and "How many customers are currently watching this video?"}
  spec.homepage      = "https://github.com/vizvamitra/watch_counter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ['watch_counter']
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.bindir        = "bin"
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sinatra", "~> 1.4"
  spec.add_runtime_dependency "sqlite3", "~> 1.3"
  spec.add_runtime_dependency "puma", "~> 2.14"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "cucumber-sinatra", "~> 0.5"
  spec.add_development_dependency "timecop", "~> 0.8"
end
