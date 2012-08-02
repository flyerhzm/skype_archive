require "sqlite3"
require "sequel"

module SkypeArchive
  class Model
    attr_reader :account_name

    def initialize(account_name)
      @account_name = account_name
    end

    def search(text)
      connection[:Messages].where("type = ? and body_xml LIKE ?", 61, "%#{text}%").all
    end

    private
      def connection
        @connection ||= Sequel.sqlite('/Library/Application\ Support/Skype/#{account_name}/main.db')
      end
  end
end
