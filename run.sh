for i in `cat links.txt`
do

	wget -O ./index http://commons.wikimedia.org/wiki/File:$i && egrep 'fullMedia' ./index | perl -F\" -alne 'print $F[3]' | sed 's/^.\{2\}//g' > image.txt
	wget `cat image.txt`
done

rm -r ./index
rm -r image.txt
