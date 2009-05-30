require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require 'rubytorrent/bencoding'

describe String do
  it 'should bencode a short string' do
    "test".to_bencoding.should == "4:test"
  end

  it 'should bencode an empty string' do
    "".to_bencoding.should == "0:"
  end

  it 'should bencode unicode' do
    "t\351st".to_bencoding.should == "4:t\351st"
  end
end

describe Integer do
  it 'should encode an integer' do
    4.to_bencoding.should == "i4e"
  end

  it 'should encode a negative integer' do
    -1.to_bencoding.should == "i-1e"
  end
end

describe Array do
  it 'should encode a numeric array' do
    [1,2,3].to_bencoding.should == "li1ei2ei3ee"
  end

  it 'should encode a mixed array' do
    [5, "test", 3].to_bencoding.should == "li5e4:testi3ee"
  end

  it 'should encode a nested array' do
    [1, [7,8]].to_bencoding.should == "li1eli7ei8eee"
  end
end

describe Hash do
  it 'should encode a hash' do
    {"foo" => "bar"}.to_bencoding.should == "d3:foo3:bare"
  end
end

describe "decoding" do
  def bstream_for(str)
    RubyTorrent::BStream.new(StringIO.new(str))
  end

  it 'should parse an integer' do
    bstream_for('i46e').first.should == 46
  end

  it 'should parse a string' do
    bstream_for('5:hello').first.should == "hello"
  end

  it 'should parse a hash' do
    bstream_for('d3:foo3:bare').first.should == {"foo" => "bar"}
  end

  it 'should parse an array' do
    bstream_for('li1ei2ei3ee').first.should == [1,2,3]
  end

  it 'should parse a nested array' do
    bstream_for('lli1ei2eeli3ei4eee').first.should == [[1,2],[3,4]]
  end
end
