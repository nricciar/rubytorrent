require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require 'rubytorrent/metainfo'
include RubyTorrent

describe MetaInfo do
  it 'should have a TypedStruct' do
    metainfo = MetaInfo.new({})
    metainfo.mii.should be_kind_of(TypedStruct)
  end 

  it 'should accept a dict and properly set the mii' do
    metainfo = MetaInfo.new({'comment' => 'test'})
    metainfo.mii.comment.should == 'test'
  end

  it 'should coerce the announce into a URI' do
    metainfo = MetaInfo.new({'announce' => 'http://example.com/'})
    metainfo.announce.should be_kind_of(URI)
  end

  it 'should support an array for the announce_list' do
    announce_list = [["http://example.com/", "http://example2.com/"]]
    announce_uris = announce_list.map{|a| a.map{|u| URI.parse(u); } }
    metainfo = MetaInfo.new({'announce-list' => announce_list})
    metainfo.mii.announce_list.should == announce_uris
  end

  it 'should fail on non-urls in the announce list' do
    metainfo = MetaInfo.new({'annouce-list' => ['a', 'b']})
    metainfo.mii.announce_list.should be_nil
  end

  it 'should return a tracker' do
    tracker = 'http://example.com/'
    metainfo = MetaInfo.new({'announce' => tracker})
    metainfo.trackers.should == [URI.parse(tracker)]
  end

  it 'should bencode' do
    metainfo = MetaInfo.new({'comment' => 'test'})
    metainfo.to_bencoding.should == "d7:comment4:teste"
  end
end
