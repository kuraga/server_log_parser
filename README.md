# ApacheLogParser

ApacheLogParser provides a high-level Ruby library for parsing web server log files
(common log format, with or without virtual hosts and combined log format) as used
by Apache, Nginx and others.

It's a fork of [Simone Carletti][]'s [ApacheLogRegex][], but abstracts the log format
to allow for a nicer response (using Ruby objects, not just Strings). ApacheLogRegex
was in turn a port of Peter Hickman's [Apache::LogRegex 1.4 Perl module][perl]
where much of the regex parts come from.

It has no dependencies and works with Ruby 2.0.

[Simone Carletti]: http://www.simonecarletti.com/
[ApacheLogRegex]: https://github.com/weppos/apachelogregex
[perl]: http://search.cpan.org/~akira/Apache-ParseLog-1.02/ParseLog.pm

## Example Usage

Much like the original, it presents a simple parser class which can then be used to
parse the lines in a log file, but returning a hash of native types:

```ruby
require 'apachelogparser'

parser = ApacheLogParser.new(format)

File.foreach('/var/log/apache/access.log') do |line|
  puts parser.parse(line)
end
```

`parse` will silently ignore errors, but if you'd prefer, `parse!` will raise a 
`ParseError` exception.

The response will look a bit like this (but with data, not datatypes):

```ruby
{
    "virtual_host" => String,
    "host" => String,
    "identity" => nil,
    "user" => nil,
    "timestamp" => DateTime,
    "request" => {"method" => String, "resource" => String, "protocol" => String},
    "status" => Integer,
    "bytes" => Integer,
    "referrer" => String,
    "user_agent" => String
}
```

Apache log files use "-" to mean no data is present and these are replaced with nil,
like the "identity" and "user" values above. Request is split into a nested hash.

## Credits

* Maintainer: Nick Charlton <hello@nickcharlton.net>
* Original library: Simon Carletti's [ApacheLogRegex][]
* Inspiration:
    - Peter Hickman's Apache::LogRegex Perl Library
    - Harry Fuecks's [Python port][].
    - Hamish Morgan's [PHP port][].

[ApacheLogRegex]: https://github.com/weppos/apachelogregex
[Python port]: http://code.google.com/p/apachelog/
[PHP port]: http://kitty0.org/

## License

Copyright 2013 Nick Charlton. ApacheLogParser is licensed under the MIT library.

