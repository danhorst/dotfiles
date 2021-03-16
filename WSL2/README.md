# WSL 2 Networking Fix for Cisco AnyConnect

If you can't connect to the Internet from WSL 2 when you're connected to a VPN using Cisco AnyConnect then these scripts can help.

They expect to be installed on the Windows host machine in `C:\Users\%YOUR_USERNAME%\WSL2`
You will have to adjust the target of the shortcut manually after you copy it there.

Once those are in place you can run `fix_net.sh` from _within_ WSL2.
You will be prompted for a sudo password in WSL 2 and then an Administrator password on the Windows host.
It _should_ work after that.
