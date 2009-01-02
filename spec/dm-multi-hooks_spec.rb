require 'rubygems'
require 'spec'
require 'dm-core'

require File.dirname(__FILE__) + '/../lib/dm-multi-hooks'

DataMapper.setup(:default, 'sqlite3::memory:')

class One
  include DataMapper::Resource
  before :create, :set_name
  after :create, :set_name

  property :id, Serial; property :name, String

 private

  def set_name
    self.name = "Barry Windicus"
  end
end

class Two
  include DataMapper::Resource
  before [ :create, :update ], :set_name
  after [ :create, :update ], :set_name

  property :id, Serial; property :name, String

 private

  def set_name
    self.name = "Bruce Carnage"
  end
end

class Three
  include DataMapper::Resource
  before :create, [ :set_name, :set_monicker ]
  after :create, [ :set_name, :set_monicker ]

  property :id, Serial; property :name, String

 private

  def set_name
    self.name = "Bob Benson"
  end

  def set_monicker
    self.name.sub! /\s/, " 'The Sandwich' "
  end
end

class Four
  include DataMapper::Resource
  before [ :create, :destroy ], [ :set_name, :set_monicker ]
  after [ :create, :destroy ], [ :set_name, :set_monicker ]

  property :id, Serial; property :name, String

 private

  def set_name
    self.name = "Bob Benson"
  end

  def set_monicker
    self.name.sub! /\s/, " 'The Sandwich' "
  end
end

describe "dm-multi-hooks" do

  before(:all) do
    @hooks_one = One.instance_hooks
    @hooks_two = Two.instance_hooks
    @hooks_three = Three.instance_hooks
    @hooks_four = Four.instance_hooks
  end

  it "should allow one hook to be assigned to one method" do
    hooks = [ { :from => One, :name => :set_name } ]

    @hooks_one[:create][:before].should == hooks
    @hooks_one[:create][:after].should == hooks

    [ :update, :save, :destroy ].each do |method|
      @hooks_one[method][:before].should be_empty
      @hooks_one[method][:after].should be_empty
    end
  end

  it "should allow one hook to be assigned to multiple methods" do
    hooks = [ { :from => Two, :name => :set_name } ]

    @hooks_two[:create][:before].should == hooks
    @hooks_two[:create][:after].should == hooks
    @hooks_two[:update][:before].should == hooks
    @hooks_two[:update][:after].should == hooks

    [ :save, :destroy ].each do |method|
      @hooks_two[method][:before].should be_empty
      @hooks_two[method][:after].should be_empty
    end
  end

  it "should allow multiple hooks to be assigned to one method" do
    hooks = [ { :from => Three, :name => :set_name }, { :from => Three, :name => :set_monicker } ]

    @hooks_three[:create][:before].should == hooks
    @hooks_three[:create][:after].should == hooks

    [ :update, :save, :destroy ].each do |method|
      @hooks_three[method][:before].should be_empty
      @hooks_three[method][:after].should be_empty
    end
  end

  it "should allow multiple hooks to be assigned to multiple methods" do
    hooks = [ { :from => Four, :name => :set_name }, { :from => Four, :name => :set_monicker } ]

    @hooks_four[:create][:before].should == hooks
    @hooks_four[:create][:after].should == hooks
    @hooks_four[:destroy][:before].should == hooks
    @hooks_four[:destroy][:after].should == hooks

    [ :update, :save ].each do |method|
      @hooks_four[method][:before].should be_empty
      @hooks_four[method][:after].should be_empty
    end

  end

end
