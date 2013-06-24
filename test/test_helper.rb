#
# = Apache Log Parser
#
# Ruby library to parse web server log files using regular expressions.
#
# Category::    
# Package::     ApacheLogParser
# Author::      Nick Charlton <hello@nickcharlton.net>
# License::     
#
#--
# SVN: $Id$
#++


$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'test/unit'
require 'apache_log_regex'

# testcase file path
TESTCASES_PATH   = File.dirname(__FILE__) + '/testcases' unless defined?(TESTCASES_PATH)
FIXTURES_PATH    = File.dirname(__FILE__) + '/fixtures'  unless defined?(FIXTURES_PATH)
