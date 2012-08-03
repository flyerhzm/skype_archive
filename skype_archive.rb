require 'fileutils'

puts "installing skype_archive gem..."
if ENV['GEM_PATH'] && ENV['GEM_PATH'].start_with?(ENV['HOME'])
  system "gem install skype_archive"
else
  system "sudo gem install skype_archive"
end

plist_path = File.expand_path("~/Library/LaunchAgents/jp.co.gree.skype_archive.plist")
if File.exists? plist_path
  system "launchctl unload #{plist_path}"
end

puts "downloading jp.co.gree.skype_archive.plist..."
system "curl -o jp.co.gree.skype_archive.plist https://raw.github.com/flyerhzm/skype_archive/master/jp.co.gree.skype_archive.plist"

FileUtils.mv "jp.co.gree.skype_archive.plist", plist_path
system "launchctl setenv PATH #{ENV['PATH']}"
system "launchctl setenv GEM_PATH #{ENV['GEM_PATH']}"
system "launchctl load #{plist_path}"

puts "skype_archive installed successfully"
