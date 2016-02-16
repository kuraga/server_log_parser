require 'test_helper'

describe WebLogParser do

  before do
    @format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
    @parser = WebLogParser.new(@format)
  end

  describe "#parse" do

    it "should parse line" do
      expected = { '%h'  => '212.74.15.68',
                   '%l'  => '-',
                   '%u'  => '-',
                   '%t'  => '[23/Jan/2004:11:36:20 +0000]',
                   '%r'  => 'GET /images/previous.png HTTP/1.1',
                   '%>s' => '200',
                   '%b'  => '2607',
                   '%{Referer}i'     => 'http://peterhi.dyndns.org/bandwidth/index.html',
                   '%{User-Agent}i'  => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.2) Gecko/20021202' }
      results = @parser.parse(read_testcase('line.log'))

      assert_kind_of(Hash, results)
      assert_match_expected_hash(expected, results)
    end

    it "should parse line with slash quote in request" do
      expected = { '%h'  => '212.74.15.68',
                   '%l'  => '-',
                   '%u'  => '-',
                   '%t'  => '[23/Jan/2004:11:36:20 +0000]',
                   '%r'  => 'GET /images/previous.png=\" HTTP/1.1',
                   '%>s' => '200',
                   '%b'  => '2607',
                   '%{Referer}i'     => 'http://peterhi.dyndns.org/bandwidth/index.html',
                   '%{User-Agent}i'  => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.2) Gecko/20021202' }
      results = @parser.parse(read_testcase('line-with-slash-quote-in-request.log'))

      assert_kind_of(Hash, results)
      assert_match_expected_hash(expected, results)
    end

    it "should parse line with slash quote in referer" do
      expected = {  '%h'  => '4.224.234.46',
                   '%l'  => '-',
                   '%u'  => '-',
                   '%t'  => '[20/Jul/2004:13:18:55 -0700]',
                   '%r'  => 'GET /core/listing/pl_boat_detail.jsp?&units=Feet&checked_boats=1176818&slim=broker&&hosturl=giffordmarine&&ywo=giffordmarine& HTTP/1.1',
                   '%>s' => '200',
                   '%b'  => '2888',
                   '%{Referer}i'     => 'http://search.yahoo.com/bin/search?p=\"grady%20white%20306%20bimini\"',
                   '%{User-Agent}i'  => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98; YPC 3.0.3; yplus 4.0.00d)' }
      results = @parser.parse(read_testcase('line-with-slash-quote-in-referer.log'))

      assert_kind_of(Hash, results)
      assert_match_expected_hash(expected, results)
    end

    it "return nil on invalid format" do
      results = @parser.parse('foobar')

      assert_nil(results)
    end

  end

  describe "#parse!" do

    it "should work" do
      testcase = read_testcase('line.log')

      expected = @parser.parse(testcase)
      results = @parser.parse!(testcase)

      assert_equal(expected, results)
    end

    it "should raise on invalid format" do
      error = assert_raises(WebLogParser::ParseError) { @parser.parse!('foobar') }
      assert_match(/Invalid format/, error.message)
    end

  end


  protected

    def read_testcase(filename)
      File.read("#{TESTCASES_PATH}/#{filename}")
    end

    def assert_match_expected_hash(expected, current)
      expected.each do |key, value|
        assert_equal(value, current[key], "Expected `#{key}` to match value `#{value}` but `#{current[:key]}`")
      end
    end

end
