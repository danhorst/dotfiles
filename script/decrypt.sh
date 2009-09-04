#!/bin/bash

# decrypt.sh
# This script decrypts a file using ssl
# http://blog.gnist.org/article.php?story=encrypt-files-with-openssl

$ext=enc
openssl enc -d -aes-256-cbc -in $1 -out ${$1%$ext}
