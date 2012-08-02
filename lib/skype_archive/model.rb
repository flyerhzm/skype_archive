require "sqlite3"
require "sequel"

module SkypeArchive
  class Model
    attr_reader :account_name

    def initialize(account_name)
      @account_name = account_name
    end

    def search(text, options={})
      if options[:skypename]
        connection[:Messages].filter(:type => 61).filter("body_xml LIKE ?", "%#{text}%").filter(:author => options[:skypename]).all
      else
        connection[:Messages].filter(:type => 61).filter("body_xml LIKE ?", "%#{text}%").all
      end
    end

    private
      def connection
        @connection ||= Sequel.sqlite('/Library/Application\ Support/Skype/#{account_name}/main.db')
      end
  end
end
