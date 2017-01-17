# OpenNet_to_xmpp
OpenNet News XMPP Encrypted Gateway
Get news from http://opennet.ru encrypt it with OpenPGP and send to Jabber.
You must have jabber client wuth OpenPGP support.

#INSTALL
apt-get install sendxmpp sqlite3 curl
chmod +x opennet_xmpp.sh

#Import PGP key
gpg --import key_file.asc

#Register Jabber bot

#Edit vars
Open opennet_xmpp.sh and edit vars, as Loin/pass/server/pgp_key and etc.

#Add script to cron.
crontab -e
*/30 * * * * /home/username/dir_of_script/opennet_xmpp.sh

Writed by Nvb13
nvb13@swissjabber.ch
