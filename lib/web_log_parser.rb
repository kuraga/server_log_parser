require 'web_log_parser/version'

class WebLogParser
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


  # Regexp instance used for parsing a log line.
  attr_reader :regexp

  # The list of field names that extracted from log format.
  attr_reader :names


  # Initializes a new parser instance with given log <tt>format</tt>.
  def initialize(format)
    @regexp = nil
    @names  = []
    @format = parse_format(format)
  end

  # Parses <tt>line</tt> according to current log <tt>format</tt>
  # and returns an hash of log field => value on success.
  # Returns <tt>nil</tt> if <tt>line</tt> doesn't match current log <tt>format</tt>.
  def parse(line)
    row = line.to_s
    row.chomp!
    row.strip!
    return unless match = regexp.match(row)

    data = {}
    names.each_with_index { |field, index| data[field] = match[index + 1] } # [0] == line
    data
  end

  # Same as <tt>WebLogParser#parse</tt> but raises a <tt>ParseError</tt>
  # if <tt>line</tt> doesn't match current <tt>format</tt>.
  #
  # ==== Raises
  #
  # ParseError:: if <tt>line</tt> doesn't match current <tt>format</tt>
  #
  def parse!(line)
    parse(line) || raise(ParseError, "Invalid format `%s` for line `%s`" % [@format, line])
  end


  protected

    # Overwrite this method if you want to use some human-readable name for log fields.
    # This method is called only once at <tt>parse_format</tt> time.
    def rename_this_name(name)
      name
    end

    # Parse log <tt>format</tt> into a suitable Regexp instance.
    def parse_format(format)
      format = format.to_s
      format.chomp!                # remove carriage return
      format.strip!                # remove leading and trailing space
      format.gsub!(/[ \t]+/, ' ')  # replace tabulations or spaces with a space

      strip_quotes = proc { |string| string.gsub(/^\\"/, '').gsub(/\\"$/, '') }
      find_quotes  = proc { |string| string =~ /^\\"/ }
      find_percent = proc { |string| string =~ /^%.*t$/ }
      find_referrer_or_useragent = proc { |string| string =~ /Referer|User-Agent/ }

      pattern = format.split(' ').map do |element|
        has_quotes = !!find_quotes.call(element)
        element = strip_quotes.call(element) if has_quotes

        self.names << rename_this_name(element)

        case
          when has_quotes
            if element == '%r' or find_referrer_or_useragent.call(element)
              /"([^"\\]*(?:\\.[^"\\]*)*)"/
            else
              '\"([^\"]*)\"'
            end
          when find_percent.call(element)
              '(\[[^\]]+\])'
          when element == '%U'
              '(.+?)'
          else
              '(\S*)'
        end
      end.join(' ')

      @regexp = Regexp.new("^#{pattern}$")
      format
    end

end
