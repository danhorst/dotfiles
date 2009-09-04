#!/bin/bash

# encrypt.h
# This script encrypts a file using ssl
# http://blog.gnist.org/article.php?story=encrypt-files-with-openssl

openssl enc -e -aes-256-cbc -salt -in $1 -out $1.enc

