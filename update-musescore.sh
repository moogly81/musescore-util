#!/usr/bin/env bash

# kill the instances of nightly build
ps -e | grep Nightly |grep mscore |grep -v grep| awk '{print $1}' | while read -r PID
do
  echo "Killing the running program on pid $PID "
  kill "$PID"
done

# cleanup older nightly versions
find  /Volumes -name 'Muse*.app' -print0 2>/dev/null | while IFS= read -r -d '' file
do
  hdiutil unmount  "$file" -force
done

find  /Applications -name  'Muse*Nightly*.app' -print0  2>/dev/null | while IFS= read -r -d '' file
do
  rm -rf "$file" 
  echo "$file removed successfully"
done

#download new version
curl  "https://ftp.osuosl.org/pub/musescore-nightlies/macos/4x/nightly/MuseScoreNightly-latest-x86_64.dmg" --output ~/Downloads/musescore-nightly.dmg


# mounting fs. It often fails the first time, I don't know why. 
while ! hdiutil mount ~/Downloads/musescore-nightly.dmg 
do 
  echo "retrying to mount ~/Downloads/musescore-nightly.dmg"
done

app_volume_name=$(ls -1rt /volumes |grep -i musescore |tail -1)
apppath=$(find "/Volumes/$app_volume_name" -name "MuseScore*.app")
application_name=$(basename "$apppath")

cp -R "$apppath"  /Applications/ 
open "/Applications/$application_name"



#diskutil list
#hdiutil detach /dev/disk4 