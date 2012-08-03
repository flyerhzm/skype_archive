require 'spec_helper'

describe SkypeArchive::Model do
  let(:connection) { DB }
  let(:model) { SkypeArchive::Model.new("gii.richard.huang") }
  before do
    Sequel.stubs(:sqlite).returns(connection)
  end

  context "#search" do
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

    it "should search by conversation" do
      model.search("message", :conversation => "flyerhzm").should have(1).item
    end
  end

  context "#sync" do
    it "should sync_contacts" do
      stub_request(:post, "#{SkypeArchive::URL}/users")
      model.sync_contacts.should have(3).items
    end

    it "should sync_conversations" do
      stub_request(:post, "#{SkypeArchive::URL}/conversations")
      model.sync_conversations.should have(1).items
    end

    it "should sync_participants" do
      stub_request(:post, "#{SkypeArchive::URL}/conversations")
      stub_request(:post, "#{SkypeArchive::URL}/conversations/JGdpaS5qYXNvbi5sYWkvMTIzNDU2Nzg5/participants")
      model.sync_participants
    end

    it "should sync_message" do
      stub_request(:post, "#{SkypeArchive::URL}/conversations")
      stub_request(:post, "#{SkypeArchive::URL}/conversations/JGdpaS5qYXNvbi5sYWkvMTIzNDU2Nzg5/messages")
      model.sync_messages
    end

    it "should sync_message with start_time and end_time" do
      stub_request(:post, "#{SkypeArchive::URL}/conversations")
      model.sync_messages(Time.now.to_i + 1, Time.now.to_i + 1000)
    end
  end
end
