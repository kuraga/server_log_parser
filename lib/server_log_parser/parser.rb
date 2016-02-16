module ServerLogParser

  class Parser

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

    # Same as <tt>ServerLogParser#parse</tt> but raises a <tt>ParseError</tt>
    # if <tt>line</tt> doesn't match current <tt>format</tt>.
    #
    # ==== Raises
    #
    # ParseError:: if <tt>line</tt> doesn't match current <tt>format</tt>
    #
    def parse!(line)
      parse(line) || raise(ParseError, "Invalid format `%s` for line `%s`" % [@format, line])
    end

    # Parses <tt>line</tt> according to current log <tt>format</tt>
    # and returns an hash of log field => typed value on success.
    # Returns <tt>nil</tt> if <tt>line</tt> doesn't match current log <tt>format</tt>.
    def handle(line)
      parsed = parse(line)
      return unless parsed

      handle_parsed(parsed)
    end

    # Same as <tt>ServerLogParser#parse</tt> but raises a <tt>ParseError</tt>
    # if <tt>line</tt> doesn't match current <tt>format</tt>.
    #
    # ==== Raises
    #
    # ParseError:: if <tt>line</tt> doesn't match current <tt>format</tt>
    #
    def parse!(line)
      parse(line) || raise(ParseError, "Invalid format `%s` for line `%s`" % [@format, line])
    end

    # Same as <tt>ServerLogParser#handle</tt> but raises a <tt>ParseError</tt>
    # if <tt>line</tt> doesn't match current <tt>format</tt>.
    #
    # ==== Raises
    #
    # ParseError:: if <tt>line</tt> doesn't match current <tt>format</tt>
    #
    def handle!(line)
      parsed = parse!(line)

      handle_parsed(parsed)
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

      def handle_parsed(parsed)
        data = {}

        parsed.each_pair do |field, value|
          data[field] = if value == '-'
            nil
          else
            case field
            when '%B', '%b', '%k', '%p', /%{\S+}p/, '%P', /%{\S+}P/, '%s', '%>s', '%I', '%O'
              Integer(value)
            when '%D', '%T'
              Float(value)
            when '%t'
              DateTime.strptime(value, '[%d/%b/%Y:%H:%M:%S %Z]')
            when '%r'
              { 'method'   => value[/^(\w*)/, 1],
                'resource' => value[/(\/\S*) /, 1],
                'protocol' => value[/.* (.*)$/, 1] }	
            else
              value
            end
          end
        end

        data
      end

  end

end
