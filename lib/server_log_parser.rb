module ServerLogParser

  COMMON_LOG_FORMAT = '%h %l %u %t \"%r\" %>s %b'
  COMMON_LOG_FORMAT_VIRTUAL_HOST = '%v %h %l %u %t \"%r\" %>s %b'
  COMBINED = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"'
  COMBINED_VIRTUAL_HOST = '%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"'

  #
  # = ParseError
  #
  # Raised in case the parser can't parse a log line with current +format+.
  #
  class ParseError < RuntimeError; end

end

require 'server_log_parser/version'
require 'server_log_parser/parser'
