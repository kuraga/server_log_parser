require 'rubygems'
require 'rake'

gem     'echoe', '>= 3.1'
require 'echoe'

$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")
require 'apache_log_parser'


# Common package properties
PKG_NAME    = ENV['PKG_NAME']    || ApacheLogParser::GEM
PKG_VERSION = ENV['PKG_VERSION'] || ApacheLogParser::VERSION
PKG_SUMMARY = "Ruby library to parse web server log files using regular expressions."
PKG_FILES   = FileList.new("{lib,test}/**/*.rb") do |files|
  files.include %w(README.md LICENSE.md)
  files.include %w(Rakefile setup.rb)
end
RUBYFORGE_PROJECT = 'apachelogparser'
 
if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end
 
 
Echoe.new(PKG_NAME, PKG_VERSION) do |p|
  p.author        = "Nick Charlton"
  p.email         = "hello@nickcharlton.net"
  p.summary       = PKG_SUMMARY
  p.description   = <<-EOF
    ApacheLogParser provides a high-level Ruby library for parsing web server \
    log files (common log format, with or without virtual hosts and combined \
    log format) as used by Apache, Nginx and others.

    It's a fork of Simone Carletti's ApacheLogRegex, but abstracts the log \
    format to allow for a nicer response (using Ruby objects, not just \
    Strings). ApacheLogRegex was in turn a port of Peter Hickman's \
    Apache::LogRegex 1.4 Perl module where much of the regex parts come from.
  EOF
  p.url           = "https://github.com/nickcharlton/apachelogparser"
  p.project       = RUBYFORGE_PROJECT

  p.need_zip      = true
  p.rcov_options  = ["--main << README.md -x Rakefile -x rcov"]
  p.rdoc_pattern  = /^(lib|README.md)/

  p.development_dependencies += ["rake  >=0.8",
                                 "echoe >=3.1"]
end


begin
  require 'code_statistics'
  desc "Show library's code statistics"
  task :stats do
    CodeStatistics.new(["ApacheLogParser", "lib"],
                       ["Tests", "test"]).to_s
  end
rescue LoadError
  puts "CodeStatistics (Rails) is not available"
end
