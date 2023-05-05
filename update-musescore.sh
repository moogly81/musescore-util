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
latest_file=$(curl -s "https://ftp.osuosl.org/pub/musescore-nightlies/macos/4x/nightly//?C\=M\;O\=A" | grep href | grep MuseScoreNightly | grep latest |grep -v master | head -1 | sed 's/^.*Muse/Muse/' | sed 's/dmg.*$/dmg/')
url="https://ftp.osuosl.org/pub/musescore-nightlies/macos/4x/nightly/$latest_file"
echo "Downloading $url"
curl -s "$url" --output ~/Downloads/musescore-nightly.dmg

size=$(du -m ~/Downloads/musescore-nightly.dmg| awk '{print $1}')
if (( size < 50 )) ; then 
  echo "The file size is only $size MB. This is suspicious. (file name :  $latest_file)"
fi



# mounting fs. It often fails the first time, I don't know why. 
i=0
while ! hdiutil mount ~/Downloads/musescore-nightly.dmg 
do 
  echo "retrying to mount ~/Downloads/musescore-nightly.dmg"
  i=$i+1
  if (( i >= 5 )) ; then break; fi
done

app_volume_name=$(ls -1rt /volumes |grep -i musescore |tail -1)
apppath=$(find "/Volumes/$app_volume_name" -name "MuseScore*.app")
application_name=$(basename "$apppath")

#echo "app_volume_name=$app_volume_name"  
#echo "apppath=$apppath"  
#echo "application_name=$application_name "

cp -R "$apppath"  /Applications/ 
open "/Applications/$application_name"



#diskutil list
#hdiutil detach /dev/disk4 
