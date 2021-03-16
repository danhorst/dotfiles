#!/bin/bash

TMP=`mktemp`
trap ctrlC INT

removeTempFiles() {
	rm -f "$TMP"
}

ctrlC() {
	echo
	echo "Trapped Ctrl-C, removing temporary files"
	removeTempFiles
	stty sane
}

echo "Current resolv.conf"
echo "-------------------"
cat /etc/resolv.conf

echo
echo "Creating new resolv.conf"
echo "------------------------"

{
	head -1 /etc/resolv.conf | grep '^#.*generated'
	for i in `/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Get-DnsClientServerAddress -AddressFamily ipv4 | Select-Object -ExpandProperty ServerAddresses"`; do
		echo nameserver $i
	done
	tail -n+2 /etc/resolv.conf | grep -v '^nameserver'
} | tr -d '\r' | tee "$TMP"

if cmp -s "$TMP" /etc/resolv.conf; then
  echo "resolv.conf does not need to be updated"
else
  echo "Installing new resolv.conf"
  (set -x; sudo cp -i "$TMP" /etc/resolv.conf)
fi

removeTempFiles

echo "Adjusting interface metric on the Cisco AnyConnect network connection"

cd /mnt/c/Windows/System32
winUser=`cmd.exe /c 'echo %USERNAME%' | sed -e 's/\r//g'`
`cmd.exe "/mnt/C/Users/$winUser/WSL2/fix-net.lnk"`
