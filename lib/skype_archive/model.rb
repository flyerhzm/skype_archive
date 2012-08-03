require "sqlite3"
require "sequel"
require "rest_client"
require "json"
require "base64"

module SkypeArchive
  class Model
    LAST_SYNC_FILE = "/tmp/skype_archive_last_sync"

    attr_reader :account_name

    def initialize(account_name)
      @account_name = account_name
    end

    def search(text, options={})
      query = connection[:Messages].filter(:type => 61).filter("body_xml LIKE ?", "%#{text}%")
      query = query.filter("from_dispname LIKE ?", "%#{options[:author]}%") if options[:author]
      query = query.filter("timestamp > ?", options[:timestamp]) if options[:timestamp]
      if options[:conversation]
        convo_ids = connection[:Conversations].filter("displayname LIKE ?", "%#{options[:conversation]}%").all.map { |convo| convo[:id] }
        query = query.filter("convo_id in ?", convo_ids)
      end
      query = query.select(:author, :from_dispname, :body_xml, :timestamp)
      query.all.map { |attrs| Message.new(attrs) }
    end

    def sync
      start_time = last_sync_time
      end_time = Time.now.to_i
      sync_contacts
      sync_conversations
      sync_participants
      sync_messages(start_time, end_time)
      update_sync_file(end_time)
    end

    def sync_contacts
      contacts = connection[:Contacts].select(:skypename, :displayname).all
      RestClient.post "#{URL}/users", contacts.to_json, :content_type => :json, :accept => :json
      contacts
    end

    def sync_conversations
      @conversations = connection[:Conversations].filter(:type => 2).select(:id, :identity, :displayname).all
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

    def last_sync_time
      if File.exists?(LAST_SYNC_FILE)
        File.read(LAST_SYNC_FILE).to_i
      else
        Time.now.to_i - 3600 * 24 * 30
      end
    end

    def update_sync_file(time)
      File.open(LAST_SYNC_FILE, 'w') do |file|
        file.puts time
      end
    end

    private
      def connection
        @connection ||= Sequel.sqlite(File.expand_path("~/Library/Application\ Support/Skype/#{account_name}/main.db"))
      end
  end
end
