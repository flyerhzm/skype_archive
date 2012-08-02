require 'spec_helper'

describe SkypeArchive::Model do
  let(:connection) { DB }
  before do
    Sequel.stubs(:sqlite).returns(connection)
  end

  it "should search messages" do
    results = SkypeArchive::Model.new("gii.richard.huang").search("gree message")
    results.should have(3).items
  end

  it "should search only text messages" do
    results = SkypeArchive::Model.new("gii.richard.huang").search("self message")
    results.should have(1).item
  end
end
