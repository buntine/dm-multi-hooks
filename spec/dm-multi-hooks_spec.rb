require 'spec'
require File.dirname(__FILE__) + '/../lib/dm-multi-hooks'

DataMapper.setup(:default, 'sqlite3::memory:')

class Cheese
  include DataMapper::Resource

  property :id, Serial
  property :name, String

end

describe "dm-multi-hooks" do

  it "should allow one hook to be assigned to one method"
  it "should allow multiple hooks to be assigned to one method"
  it "should allow one hook to be assigned to multiple methods"
  it "should allow multiple hooks to be assigned to multiple methods"

end
