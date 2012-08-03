gem install skype_archive

if [ -f ~/Library/LaunchAgents/jp.co.gree.skype_archive.plist ]
then
  launchctl unload ~/Library/LaunchAgents/jp.co.gree.skype_archive.plist
fi

curl -o jp.co.gree.skype_archive.plist https://raw.github.com/flyerhzm/skype_archive/master/jp.co.gree.skype_archive.plist

mv jp.co.gree.skype_archive.plist ~/Library/LaunchAgents/jp.co.gree.skype_archive.plist
launchctl setenv PATH $PATH
launchctl setenv GEM_PATH $GEM_PATH
launchctl load ~/Library/LaunchAgents/jp.co.gree.skype_archive.plist
