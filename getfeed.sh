#!/bin/bash

#OUTPUTFILE=getfeed.txt		#output file for the script

command -v xml2 >/dev/null 2>&1 || { echo >&2 "I require xml2 but it's not installed.  Aborting."; exit 1; }

while getopts ":f::d::o::t:" opt; do
  case $opt in
   	f) 
      		FEED=$OPTARG
      	;;
	d)
		DISPLAY=$OPTARG
	;;
	o)
		OUTPUTFILE=$OPTARG
	;;
	\?)
      		echo "Invalid option: -$OPTARG" >&2
      	;;
  esac
done


TRIM=$((2*$DISPLAY))

wget -q -O- $FEED | xml2 |grep '/rss/channel/item/title\|/rss/channel/item/link' | sed -e 's/\/rss\/channel\/item\/title=//g' -e 's/\/rss\/channel\/item\/link=//g' > /tmp/getfeed.temp

#strip whitespace
sed '/^$/d' /tmp/getfeed.temp > /tmp/getfeed2.temp

#delets all but the first 2 times the lines to be displayed

head -n $TRIM /tmp/getfeed2.temp > $OUTPUTFILE

#delete the temp file
rm /tmp/getfeed.temp
rm /tmp/getfeed2.temp

#this for loop joins lines so that there aren't title lines followed by links but title and link in a single line
for i in $(eval echo {1..$DISPLAY})
do
        head -n 2 $OUTPUTFILE | tr '\n' '\040' >> $OUTPUTFILE
        echo >> $OUTPUTFILE
	
	for j in {1..2}
	do
		sed -i '1d' $OUTPUTFILE
	done

done

