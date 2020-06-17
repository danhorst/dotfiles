#!/bin/bash

if grep --quiet danhorst "$HOME/.ssh/id_rsa.pub"; then
  echo "Using personal key. No action needed."
  exit 0
else
  echo "Not using personal key. Please switch SSH keys"
  exit 1
fi
