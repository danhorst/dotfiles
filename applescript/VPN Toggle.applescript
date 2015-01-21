-- Script by @porqz: https://github.com/porqz/My-AppleScripts
-- Toggles connection to VPN.
-- The name of VPN sets in this variable ↓ (see its value in System Preferences → Network)

set VPNServiceName to "Notre Dame VPN"

tell application "System Events"
  tell current location of network preferences
    set VPNservice to service VPNServiceName
    set isConnected to connected of current configuration of VPNservice

    if isConnected then
      disconnect VPNservice
    else
      connect VPNservice
    end if
  end tell
end tell

