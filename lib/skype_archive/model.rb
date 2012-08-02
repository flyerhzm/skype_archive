require "sqlite3"
require "sequel"

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
      query.all
    end

    private
      def connection
        @connection ||= Sequel.sqlite('/Library/Application\ Support/Skype/#{account_name}/main.db')
      end
  end
end
