#!/bin/bash

# I had to write two different HTML parsing scripts bcs:
# I fiugured out that if you see the page source in a whatever http://commons.wikimedia.org/wiki/File:IMAGE
# You can find the Author/Username tag shown in two different ways:
# A Username who doesn't have a Userpage
#	<a href="/w/index.php?title=User:XXXX&amp;action=edit&amp;redlink=1"
# A Username who has a Userpage
#	<a href="/wiki/User:XXXX"


 for i in `cat links.txt`
 do
 	# Download html page from the link
	wget -O ./index http://commons.wikimedia.org/wiki/File:$i

	# Get the Full Image url and store it in image.log
 	egrep 'fullMedia' ./index | perl -F\" -alne 'print $F[3]' | sed 's/^.\{2\}//g' > image.log

 	# Get usernam (for users without a User Page)
	egrep 'title=User:' ./index | perl -F\" -alne 'print $F[1]' | sed -n 's/.*index.php?title=User:\([^"]*\)&amp;action=edit&amp;redlink=1.*/\1/p' > user.log
	USERDIR="$(cat user.log)"

	# If the user doesn't have a User Page then execute the html parsing for a user who has a page
	# else just download the photo from the user without a User Page
	if [[ ! $USERDIR ]];
		then

			egrep '/wiki/User:' ./index | perl -F\" -alne 'print $F[1]' | sed 's/^.\{11\}//g' | head -1 > user.log
			USERDIR="$(cat user.log)"

			[ ! -d ${USERDIR} ] && mkdir -p ${USERDIR} || :

			wget --directory-prefix=${USERDIR} `cat image.log`

		else
			[ ! -d ${USERDIR} ] && mkdir -p ${USERDIR} || :
			wget --directory-prefix=${USERDIR} `cat image.log`

	fi
 
done

rm -r image.log user.log