require 'spec_helper'

describe SkypeArchive do
  let(:connection) { DB }
  let(:model) { SkypeArchive::Model.new("gii.richard.huang") }
  before do
    Sequel.stubs(:sqlite).returns(connection)
  end

  it "should call SkypeArchive::Model to search" do
    SkypeArchive.search("gii.richard.huang", "self message").should have(1).item
  end
end
