# OpenNet_to_xmpp
Парсер новостей с сайта Opennet.ru в Jabber с поддержкой шифрования OpenPGP.

# Установка
Для работы скрипта требуются sendxmpp, sqlite3, curl

apt-get install sendxmpp sqlite3 curl
git clone https://github.com/nvb13/OpenNet_to_xmpp.git
cd OpenNet_to_xmpp/
chmod +x opennet_xmpp.sh

# Настройка
Зарегистрируйте Jabber аккаунт бота на любом сервере.
Заполните поля в файле opennet_xmpp.sh

Jid=""     # Логин бота без собаки и хоста.
Pass=""    # Пароль бота
JServer="" # Сервер бота
Send_to=""  # Jabber ID получателя куда будут приходить новости test@example.com
Crypt="1"   # Шифровать сообщения с OpenPGP или нет. Значения 1 или 0
Key_Name="" # Имя вашего PGP ключа. Например my_key

Если используете шифрование, то импортируйте публичный ключ получателя.
gpg --import key_file.asc где key_file.asc файл публичного ключа получателя

Проверьте работу скрипта ./opennet_xmpp.sh
Если все работает добавьте задание в cron

crontab -e
*/30 * * * * /home/username/OpenNet_to_xmpp/opennet_xmpp.sh

# Автор nvb13

# ENGLISH
OpenNet News XMPP Encrypted Gateway
Get news from http://opennet.ru encrypt it with OpenPGP and send to Jabber.         
You must have jabber client wuth OpenPGP support.

# INSTALL
apt-get install sendxmpp sqlite3 curl     
git clone https://github.com/nvb13/OpenNet_to_xmpp.git
cd OpenNet_to_xmpp/
chmod +x opennet_xmpp.sh

# Import PGP key
gpg --import key_file.asc

# Register Jabber bot

# Edit vars
Open opennet_xmpp.sh and edit vars, as Loin/pass/server/pgp_key and etc.

# Add script to cron.
crontab -e
*/30 * * * * /home/username/OpenNet_to_xmpp/opennet_xmpp.sh

Writed by Nvb13
nvb13@swissjabber.ch
