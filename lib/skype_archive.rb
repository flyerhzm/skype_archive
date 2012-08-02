require "skype_archive/version"
require "sqlite3"
require "sequel"
require "json"

module SkypeArchive
  autoload :Model, "skype_archive/model"
  autoload :Message, "skype_archive/message"

  def self.search(account_name, text)
    Model.new(account_name).search(text)
  end
end
