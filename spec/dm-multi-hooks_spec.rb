require 'rubygems'
require 'spec'
require 'dm-core'

require File.dirname(__FILE__) + '/../lib/dm-multi-hooks'

DataMapper.setup(:default, 'sqlite3::memory:')

class One
  include DataMapper::Resource
  before :create, :set_name; after :create, :set_name
  property :id, Serial; property :name, String

 private

  def set_name
    self.name = "Barry Windicus"
  end
end

class Two
  include DataMapper::Resource
  before [ :create, :update ], :set_name; after [ :create, :update ], :set_name
  property :id, Serial; property :name, String

 private

  def set_name
    self.name = "Bruce Carnage"
  end
end

describe "dm-multi-hooks" do

  before(:all) do
    @hooks_one = One.instance_hooks
    @hooks_two = Two.instance_hooks
#    @hooks_three = Three.instance_hooks
#    @hooks_four = Four.instance_hooks
  end

  it "should allow one hook to be assigned to one method" do
    @hooks_one[:create][:before].should == [ { :from => One, :name => :set_name } ]
    @hooks_one[:create][:after].should == [ { :from => One, :name => :set_name } ]

    [ :update, :save, :destroy ].each do |method|
      @hooks_one[method][:before].should be_empty
      @hooks_one[method][:after].should be_empty
    end
  end

  it "should allow one hook to be assigned to multiple methods" do
    @hooks_two[:create][:before].should == [ { :from => Two, :name => :set_name } ]
    @hooks_two[:create][:after].should == [ { :from => Two, :name => :set_name } ]
    @hooks_two[:update][:before].should == [ { :from => Two, :name => :set_name } ]
    @hooks_two[:update][:after].should == [ { :from => Two, :name => :set_name } ]

    [ :save, :destroy ].each do |method|
      @hooks_two[method][:before].should be_empty
      @hooks_two[method][:after].should be_empty
    end
  end

  it "should allow multiple hooks to be assigned to one method"
  it "should allow multiple hooks to be assigned to multiple methods"

end
