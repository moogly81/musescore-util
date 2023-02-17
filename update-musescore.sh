#!/usr/bin/env bash

osascript -e 'quit app "MuseScore"'

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
curl  "https://ftp.osuosl.org/pub/musescore-nightlies/macos/4x/nightly/MuseScoreNightly-latest-x86_64.dmg" > ~/Downloads/musescore-nightly.dmg
sleep 1
hdiutil mount ~/Downloads/musescore-nightly.dmg


 appname=$(ls -1rt /volumes |grep -i musescore |tail -1)
 echo "appname=$appname"

 find "/Volumes/$appname/" -name "MuseScore*.app"
 apppath=$(find "/Volumes/$appname" -name "MuseScore*.app")

echo "apppath=$apppath"
cp -R "$apppath"  /Applications/ 

application_name=$(basename "$apppath")
echo "/Applications/$application_name"

open "/Applications/$application_name"

