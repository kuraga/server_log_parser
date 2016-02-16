$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'web_log_parser'

require 'minitest/autorun'

# testcase file path
TESTCASES_PATH   = File.dirname(__FILE__) + '/testcases' unless defined?(TESTCASES_PATH)
FIXTURES_PATH    = File.dirname(__FILE__) + '/fixtures'  unless defined?(FIXTURES_PATH)
