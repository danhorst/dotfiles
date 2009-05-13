#!/bin/sh
export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:$PATH"
ln -s /opt/local/var/run/mysql5/mysqld.sock /tmp/mysql.sock
cd /Users/danh/Dropbox/Work/Wiki && gitjour serve
open /Applications/LightSky\ Webmail.app/
open /Applications/Firefox.app
open /Applications/VirtualBox.app
open /Applications/Utilities/Terminal.app
