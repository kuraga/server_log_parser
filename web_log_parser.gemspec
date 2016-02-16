require File.expand_path("../lib/web_log_parser/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "web_log_parser"
  spec.version       = WebLogParser::VERSION
  spec.authors       = ["Nick Charlton"]
  spec.email         = ["hello@nickcharlton.net"]
  spec.summary       = %q{Ruby library to parse web server log files using regular expressions.}
  spec.description   = %q{WebLogParser provides a high-level Ruby library for parsing web server log files (common log format, with or without virtual hosts and combined log format) as used by Apache, Nginx and others.}
  spec.homepage      = "https://github.com/nickcharlton/web_log_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.5"
  spec.add_development_dependency "minitest", "~> 5.8"
end
