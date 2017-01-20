#!/bin/bash

#################################
#				#
#	Opennet.ru Jabber	#
#	   News Parser		#
#				#
#################################

### Login/Pass/Server of bot ####

Jid=""     # Only login: test
Pass=""    # Password
JServer="" # Exapmle.com

#################################

### Jid/PGP key of recipient ####

Send_to=""  # Jid: test@example.com
Crypt="1"   # Encrypt with OpenPGP or not: 1,0
Key_Name="" # PGP key name: my_key

#################################


sqlite3=`which sqlite3`
DB_FILE=./opennet_db.db

$sqlite3 $DB_FILE  "

        create table IF NOT EXISTS  news (
	   id integer primary key autoincrement,
           News TEXT UNIQUE,);"

# Get news from Opennet.ru, and remove trash
curl -s http://www.opennet.ru/opennews/opennews_3.txt | iconv -f koi8-r \
| cut -d '<' -f 8 | cut -d '"' -f 2,3 | sed 's/"//g' | sed 's/>/ /g' \
| sed 's/\([а-я]*\) \([а-я]*\)/\2 \1/'  > /tmp/opennet_temp.txt


# Wrirt news to database
while read line
 do
	$sqlite3 $DB_FILE  "insert into news (News) values  ('""$line""')"

	if [ $? == "0" ];then # If news not in database, encrypt it and send it to recipient

		if [ "$Crypt" == 1 ]; then
                  msg=$(echo "$line" | gpg -e -r "$Key_Name" --armor | grep -v 'PGP MESSAGE' | grep -v '^$')
                  msg_tmp="/tmp/$(( ( RANDOM % 25400 )  + 1 ))"

                  echo "<message to='$Send_to' from='$Jid@$JServer' type='chat'>" >> $msg_tmp
                  echo "<body>This message is encrypted.</body>" >> $msg_tmp
                  echo "<x xmlns='jabber:x:encrypted'>$msg</x>" >> $msg_tmp
                  echo "</message>" >> $msg_tmp

                  cat $msg_tmp | sendxmpp -u "$Jid" -p "$Pass" -j "$JServer" -t --raw
                else #Send not encrypted message
                  echo "$line"  | sendxmpp -u "$Jid" -p "$Pass" -j "$JServer" -e -t "$Send_to"
                fi
	fi
  sleep 2
 done < "/tmp/opennet_temp.txt"

rm -rf /tmp/opennet_temp.txt "$msg_tmp"

exit 0;
