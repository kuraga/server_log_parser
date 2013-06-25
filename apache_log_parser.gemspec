# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apache_log_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "apache_log_parser"
  spec.version       = ApacheLogParser::VERSION
  spec.authors       = ["Nick Charlton"]
  spec.email         = ["hello@nickcharlton.net"]
  spec.summary       = %q{Ruby library to parse web server log files using regular expressions.}
  spec.description   = %q{ApacheLogParser provides a high-level Ruby library for parsing web server log files (common log format, with or without virtual hosts and combined log format) as used by Apache, Nginx and others.}
  spec.homepage      = "https://github.com/nickcharlton/apache_log_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
