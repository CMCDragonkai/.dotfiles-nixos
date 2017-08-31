# Default settings for MySQL
# These settings are designed for a profile-local database.
# This sets mysql to be completely UTF8
# The server ignores the client connections that don't use UTF8
# On initial setup, do this:
# mysqld --initialize-insecure

[client]
user=root
port=3306
socket="/tmp/mysql.sock"
default-character-set=utf8mb4

[mysql]
prompt='Ｍ[\u@\h@\d] » '
pager='less --quit-if-one-screen --no-init --LONG-PROMPT --HILITE-UNREAD --status-column --chop-long-lines --shift .3'
default-character-set=utf8mb4

[mysqld]
port=3306
socket="/tmp/mysql.sock"
datadir="PH_LOCALDATA/mysql"
tmpdir="/tmp"
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
character-set-client-handshake=FALSE
innodb_large_prefix=TRUE
event_scheduler=ON

# Use `\G` instead of `;` to produce vertical output.
