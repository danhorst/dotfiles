set status to do shell script "/usr/sbin/networksetup -getairportpower en0 | awk '{ print $4 }'"
if status = "On" then
  do shell script "/usr/sbin/networksetup -setairportpower en0 off"
else
  do shell script "/usr/sbin/networksetup -setairportpower en0 on"
end if

