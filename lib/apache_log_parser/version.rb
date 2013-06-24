#
# = Apache Log Parser
#
# Ruby library to parse web server log files using regular expressions.
#
# Category::    
# Package::     ApacheLogParser
# Author::      Nick Charlton <hello@nickcharlton.net>
# License::     MIT License
#
#--
# SVN: $Id$
#++


class ApacheLogParser
  
  module Version #:nodoc:
    MAJOR = 0
    MINOR = 1
    TINY  = 0
    
    STRING = [MAJOR, MINOR, TINY].join('.')
  end
  
  VERSION         = Version::STRING
  STATUS          = 'alpha'
  BUILD           = ''.match(/(\d+)/).to_a.first
  
end
