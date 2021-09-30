#!/data/data/com.termux/files/usr/bin/bash
if [ -d "$PREFIX/share/debian-bullseye" ]; then
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Uninstalling Debian (Bullseye), please wait...\n\e[31m"
rm -rf "$PREFIX/share/debian-bullseye"
rm -f "$PREFIX/bin/start-debian-bullseye"
printf "\e[34m[\e[32m*\e[34m]\e[36m Uninstall successfully.\n\n\e[0m"
exit
fi
printf "\n\e[31mError: distribution Debian (Bullseye) is not installed.\n\n\e[0m"
