require "skype_archive/version"
require "sqlite3"
require "sequel"
require "json"

module SkypeArchive
  URL = "http://qa1.api.openfeint.com:8088"

  autoload :Model, "skype_archive/model"
  autoload :Message, "skype_archive/message"

  def self.search(account_name, text)
    Model.new(account_name).search(text)
  end

  def self.sync
    Dir[File.expand_path("~/Library/Application\ Support/Skype/*")].each do |path|
      name = File.basename(path)
      if name =~ /^gii\./
        Model.new(name).sync
      end
    end
  end
end
