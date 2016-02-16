# ServerLogParser

ServerLogParser provides a high-level Ruby library for parsing apache server log files
(common log format, with or without virtual hosts and combined log format) as used
by Apache, Nginx and others.

It's a fork of [ApacheLogRegex](https://github.com/weppos/apachelogregex),
which was in turn a port of [Apache::LogRegex 1.4 Perl module](http://search.cpan.org/~akira/Apache-ParseLog-1.02/ParseLog.pm).
where much of the regex parts come from.

## Installation

```sh
gem install server_log_parser
```

## Usage

### Initialization

```ruby
require 'server_log_parser'

parser = ServerLogParser::Parser(ServerLogParser::COMBINED_VIRTUAL_HOST)
# or:
# parser = ServerLogParser::Parser.new('%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"')
```

### Parsing

```ruby
File.foreach('/var/log/apache/access.log') do |line|
  parsed = parser.parse(line)
  # {
  #   '%h'  => '212.74.15.68',
  #   '%l'  => '-',
  #   '%u'  => '-',
  #   '%t'  => '[23/Jan/2004:11:36:20 +0000]',
  #   '%r'  => 'GET /images/previous.png HTTP/1.1',
  #   '%>s' => '200',
  #   '%b'  => '2607',
  #   '%{Referer}i'     => 'http://peterhi.dyndns.org/bandwidth/index.html',
  #   '%{User-Agent}i'  => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.2) Gecko/20021202'
  # }
end
```

`ServerLogParser#parse` will silently ignore errors, but if you'd prefer,
`ServerLogParser#parse!` will raise a  `ParseError` exception.

Apache log files use "-" to mean no data is present and these are replaced with nil,
like the "identity" and "user" values above. Request is split into a nested hash.

### Log Formats

The log format is specified using a rather verbose constant, which map out like:

Name                                 | Constant                                          | Apache Format
------------------------------------ | ------------------------------------------------- | ---------------------------------------------------------------------
Common Log Format                    | `ServerLogParser::COMMON_LOG_FORMAT`              | `%h %l %u %t \"%r\" %>s %b`
Common Log Format with virtual hosts | `ServerLogParser::COMMON_LOG_FORMAT_VIRTUAL_HOST` | `%v %h %l %u %t \"%r\" %>s %b`
Combined                             | `ServerLogParser::COMBINED`                       | `%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"`
Combined with virtual hosts          | `ServerLogParser::COMBINDED_VIRTUAL_HOST`         | `%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"`


## Author

Alexander Kurakin <<kuraga333@mail.ru>>

## Feedback and contribute

<https://github.com/kuraga/server_log_parser/issues>

## License

MIT
