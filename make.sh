#!/bin/bash
#Creator george_marGR on Twitter
simjectdir="/opt/simject"
tweaksdir="/Users/gmar/Tweaks"
if [ $# -ne 1 ]; then
  echo "You must give tweak name as arg1"
else
  sim=`ps -x | grep /Library/Developer/CoreSimulator/Profiles/Runtimes/iOS | wc -l`
  if [ $sim == 1 ]; then
    echo "Running simulator"
    open -a Simulator
    sleep 10;
  fi
  echo "Theak name is => "$1
  echo "Accessing the directory => "$tweaksdir"/"$1
  prev=`pwd`
  cd $tweaksdir/$1 2> /dev/null
  cur=`pwd`
  if [ "$prev" == "$cur" ]; then
    echo "Unable to access directory => "$tweaksdir"/"$1
  else
    echo "Directory => "$tweaksdir"/"$1 "accessed"
    echo "Making tweak "$1
    make
    echo "Deleting "$1".dylib and "$1".plist files from "$simjectdir
    rm $simjectdir/$1.plist 2> /dev/null
    rm $simjectdir/$1.dylib 2> /dev/null
    echo "Copying new "$1".plist and "$1".dylib to "$simjectdir
    cp ./.theos/obj/iphone_simulator/$1.dylib $simjectdir
    cp ./$1.plist $simjectdir
    echo "Files copied"
    read -p "You want me to restart the simulator?[y/n] " ch
    if [ $ch == "y" ]; then
      cd $simjectdir/bin
      ./respring_simulator
      echo "Simulator restarted"
    fi
  fi
fi
