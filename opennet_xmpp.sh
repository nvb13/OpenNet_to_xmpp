#!/bin/bash

#################################
#				                        #
#	      Opennet.ru Jabber	      #
#	         News Grubber		      #
#			                        	#
#################################

### Login/Pass/Server of bot ####

Jid=""     # Only login: test
Pass=""    # Password
JServer="" # Exapmle.com

#################################

### Jid/PGP key of recipient ####

Send_to=""  # Jid: test@example.com
Key_Name="" # PGP key name: my_key

#################################


sqlite3=`which sqlite3`
DB_FILE=./opennet_db.db

$sqlite3 $DB_FILE  "

        create table IF NOT EXISTS  news (
		id integer primary key autoincrement,
                News TEXT UNIQUE,
		Date DATETIME,
		Time DATETIME);"

# Get news from Opennet.ru, and remove trash
curl -s  https://www.opennet.ru/opennews/ | iconv -f koi8-r | grep -a  title2 \
| cut -d '>' -f 2,3 | cut -d '"' -f 2,3 \
| sed 's/"//g' | sed 's/class=title2>//g'\
| sed 's/<\/a//g' | sed 's/^/http:\/\/opennet.ru/g' > /tmp/opennet_temp.txt


# Wrirt news to database
while read line
 do
	$sqlite3 $DB_FILE  " insert into news (News,Date,Time) values  ('""$line""', strftime('%Y-%m-%d'), strftime('%H:%M:%S') )"

	if [ $? == "0" ];then # If news not in database, encrypt it and send it to recipient

		msg=$(echo "$line" | gpg -e -r "$Key_Name" --armor | grep -v 'PGP MESSAGE' | grep -v '^$')

		msg_tmp="/tmp/$(( ( RANDOM % 25400 )  + 1 ))"
		rm -rf $msg_tmp
		echo "<message to='$Send_to' from='$Jid@$JServer' type='chat'>" >> $msg_tmp
		echo "<body>This message is encrypted.</body>" >> $msg_tmp
		echo "<x xmlns='jabber:x:encrypted'>$msg</x>" >> $msg_tmp
		echo "</message>" >> $msg_tmp

		cat $msg_tmp | sendxmpp -v -u "$Jid" -p "$Pass" -j "$JServer" -t --raw
	fi

 done < "/tmp/opennet_temp.txt"

rm -rf /tmp/opennet_temp.txt

exit 0;
