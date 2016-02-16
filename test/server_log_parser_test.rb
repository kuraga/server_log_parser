require 'test_helper'

describe ServerLogParser do

  before do
    @format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
    @parser = ServerLogParser.new(@format)
  end

  describe "constants" do

    it "should be correct" do
      assert_equal(ServerLogParser::COMMON_LOG_FORMAT, '%h %l %u %t \"%r\" %>s %b')
      assert_equal(ServerLogParser::COMMON_LOG_FORMAT_VIRTUAL_HOST, '%v %h %l %u %t \"%r\" %>s %b')
      assert_equal(ServerLogParser::COMBINED, '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"')
      assert_equal(ServerLogParser::COMBINED_VIRTUAL_HOST, '%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"')
    end

  end

  describe "regular expression" do

    it "should be correct" do
      regexp = '(?-mix:^(\\S*) (\\S*) (\\S*) (\\[[^\\]]+\\]) (?-mix:"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)") (\\S*) (\\S*) (?-mix:"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)") (?-mix:"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)")$)'

      assert_equal(@parser.regexp.to_s, regexp)
    end

  end

end
