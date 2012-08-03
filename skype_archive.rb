require 'fileutils'

system "gem install skype_archive"

plist_path = File.expand_path("~/Library/LaunchAgents/jp.co.gree.skype_archive.plist")
if File.exists? plist_path
  system "launchctl unload #{plist_path}"
end

system "curl -o jp.co.gree.skype_archive.plist https://raw.github.com/flyerhzm/skype_archive/master/jp.co.gree.skype_archive.plist"

FileUtils.mv "jp.co.gree.skype_archive.plist", plist_path
system "launchctl setenv PATH #{ENV['PATH']}"
system "launchctl setenv GEM_PATH #{ENV['GEM_PATH']}"
system "launchctl load #{plist_path}"
