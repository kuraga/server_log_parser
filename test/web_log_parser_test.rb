require 'test_helper'

describe WebLogParser do

  before do
    @format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
    @parser = WebLogParser.new(@format)
  end

  describe "regular expression" do

    it "should be correct" do
      regexp = '(?-mix:^(\\S*) (\\S*) (\\S*) (\\[[^\\]]+\\]) (?-mix:"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)") (\\S*) (\\S*) (?-mix:"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)") (?-mix:"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)")$)'

      assert_equal(@parser.regexp.to_s, regexp)
    end

  end

end
