require 'spec_helper'

describe SkypeArchive::Model do
  let(:connection) { DB }
  let(:model) { SkypeArchive::Model.new("gii.richard.huang") }
  before do
    Sequel.stubs(:sqlite).returns(connection)
  end

  it "should search messages" do
    model.search("gree message").should have(3).items
  end

  it "should search only text messages" do
    model.search("self message").should have(1).item
  end

  it "should search by user" do
    model.search("message", :skypename => "gii.jason.lai").should have(2).items
  end

  it "should search by timestamp" do
    timestamp = Time.now.to_i - 2400
    model.search("message", :timestamp => timestamp).should have(3).items
  end
end
