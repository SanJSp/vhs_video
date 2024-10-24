#! /usr/bin/bash

# get capitzalized creation date of each file and add drawtext filter containing creation date
for f in *.MP4 ; do 
	FILE_CREATION_DATE=`date -r $f "+%d %b %Y"`;
	FILE_CREATION_DATE=${FILE_CREATION_DATE^^};
	echo ${FILE_CREATION_DATE};
	ffmpeg -i $f -vf "drawtext=text='${FILE_CREATION_DATE}':fontsize=24:fontcolor='white':x=w-tw-50:y=h-th-50" "${f%%.*}_timecoded.mkv" 
done;

touch list.txt
echo "" > list.txt

# add files in creation time order to list of files to concat
for fi in *_timecoded.mkv ; do 
	echo file \'$fi\' >> list.txt;
done;

# concat files using default compression
ffmpeg -f concat -safe 0 -i list.txt -c copy stitched-video.mp4

# delete all intermediate files
rm *_timecoded.mkv
