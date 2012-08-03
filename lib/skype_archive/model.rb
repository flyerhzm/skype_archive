require "sqlite3"
require "sequel"
require "active_support/core_ext"
require "rest_client"
require "json"
require "base64"

module SkypeArchive
  class Model
    attr_reader :account_name

    def initialize(account_name)
      @account_name = account_name
    end

    def search(text, options={})
      query = connection[:Messages].filter(:type => 61).filter("body_xml LIKE ?", "%#{text}%")
      query = query.filter(:author => options[:skypename]) if options[:skypename]
      query = query.filter("timestamp > ?", options[:timestamp]) if options[:timestamp]
      if options[:conversation]
        convo_ids = connection[:Conversations].filter("displayname LIKE ?", "%#{options[:conversation]}%").all.map { |convo| convo[:id] }
        query = query.filter("convo_id in ?", convo_ids)
      end
      query = query.select(:author, :from_dispname, :body_xml, :timestamp)
      query.all.map { |attrs| Message.new(attrs) }
    end

    def sync
      start_time = Time.now.yesterday.at_beginning_of_day.to_i
      end_time = Time.now.yesterday.at_midnight.to_i
      sync_contacts
      sync_conversations
      sync_participants
      sync_messages(start_time, end_time)
    end

    def sync_contacts
      contacts = connection[:Contacts].select(:skypename, :displayname).all
      RestClient.post "#{URL}/users", contacts.to_json, :content_type => :json, :accept => :json
      contacts
    end

    def sync_conversations
      @conversations = connection[:Conversations].select(:id, :identity, :displayname).all
      RestClient.post "#{URL}/conversations", @conversations.to_json, :content_type => :json, :accept => :json
      @conversations
    end

    def sync_participants
      @conversations or sync_conversations
      @conversations.each do |convo|
        participants = connection[:Participants].filter(:convo_id => convo[:id]).select(:identity).all
        unless participants.empty?
          url = "#{URL}/conversations/#{Base64.encode64(convo[:identity])[0...-1]}/participants"
          RestClient.post url, participants.to_json, :content_type => :json, :accept => :json
        end
      end
    end

    def sync_messages(start_time=0, end_time=Time.now.to_i)
      @conversations or sync_conversations
      @conversations.each do |convo|
        messages = connection[:Messages].filter("convo_id = ? and timestamp >= ? and timestamp <= ?", convo[:id], start_time, end_time).
                                         select(:author, :from_dispname, :remote_id, :body_xml, :timestamp).
                                         all.map { |attrs| Message.new(attrs) }
        unless messages.empty?
          url = "#{URL}/conversations/#{Base64.encode64(convo[:identity])[0...-1]}/messages"
          RestClient.post url, messages.to_json, :content_type => :json, :accept => :json
        end
      end
    end

    private
      def connection
        @connection ||= Sequel.sqlite(File.expand_path("~/Library/Application\ Support/Skype/#{account_name}/main.db"))
      end
  end
end
