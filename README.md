# OpenNet_to_xmpp
OpenNet News XMPP Encrypted Gateway

#INSTALL
apt-get install sendxmpp sqlite3 curl
chmod +x opennet_xmpp.sh

#Import PGP key
gpg --import key_file.asc

#Register Jabber bot

#Open opennet_xmpp.sh and edit vars, as Loin/pass/server/pgp_key and etc.

#Add script to cron.
crontab -e
*/30 * * * * /home/username/dir_of_script/opennet_xmpp.sh

Writed by Nvb13
nvb13@swissjabber.ch
