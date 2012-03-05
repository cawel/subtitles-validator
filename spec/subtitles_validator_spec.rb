require File.expand_path(File.dirname(__FILE__) + '/../validator')

TEST_DATA = <<-eos
1
00:00:06,244 --> 00:00:09,004
The public has a very romantic idea of what wine's about.   

2
00:00:09,984 --> 00:00:14,373
They think it's some little guy, like me, working in the cellar,

3
00:00:13,000 --> 00:00:12,777
This subtitle ends before it starts.
eos


describe SubtitlesValidator do
  let(:validator) { SubtitlesValidator.new }

  before do
    validator.stub(:file_data).and_return(TEST_DATA)
    @hash = validator.parse_data
  end

  context "parsing" do

    it "should build a hash with a key for each subtitle" do
      @hash.class.should == Hash
      @hash.size.should == 3
    end

    it "should parse the start and stop markers" do
      @hash.keys.first.should == "1"
      @hash["1"][:start].should == "00:00:06,244"
      @hash["1"][:stop].should == "00:00:09,004"

      @hash.keys.last.should == "3"
      @hash["3"][:start].should == "00:00:13,000"
      @hash["3"][:stop].should == "00:00:12,777"
    end
  end

  context "validating" do

    before do 
      validator.validate @hash
      @errors = validator.errors
    end

    it "should detect a total of 2 errors" do
      @errors.size.should == 2
    end

    it "should detect an invalid subtitle" do
      @errors[0].should match(/subtitle #3 is invalid/)
    end

    it "should detect an overlapping subtitle" do
      @errors[1].should match(/subtitle #3 is overlapping/)
    end

  end

end
