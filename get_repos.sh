#!/bin/bash

update=0;
while getopts ":u" flag; do
 case $flag in
   u) # Handle the update flag
   update=1
   ;;
 esac
done

if [[ $update -eq 1 ]]
then
 cd valis/valis
 git pull
 cd ../../
 cd zora/zora
 git pull
 cd ../../
else
 git clone https://github.com/sdss/valis.git valis/valis
 git clone https://github.com/sdss/zora.git zora/zora
fi