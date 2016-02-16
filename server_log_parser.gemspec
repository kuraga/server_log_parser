require File.expand_path("../lib/server_log_parser/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "server_log_parser"
  spec.version       = ServerLogParser::VERSION
  spec.authors       = ["Alexander Kurakin"]
  spec.email         = ["kuraga333@mail.ru"]
  spec.summary       = %q{Ruby library to parse Apache server log files using regular expressions.}
  spec.description   = %q{ServerLogParser provides a high-level Ruby library for parsing server server log files (common log format, with or without virtual hosts and combined log format) as used by Apache, Nginx and others.}
  spec.homepage      = "https://github.com/kuraga/server_log_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.5"
  spec.add_development_dependency "minitest", "~> 5.8"
end
