#!/data/data/com.termux/files/usr/bin/bash
directory="debian-bullseye"
distribution="Debian Bullseye"
if [ ! -d "${PREFIX}/share/${directory}" ]; then
printf "\n\e[31mError: distribution ${distribution} is not installed.\e[0m\n\n"
exit
fi
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Uninstalling ${distribution}, please wait...\e[0m\n"
rm -rf "${PREFIX}/share/${directory}"
rm -f "${PREFIX}/bin/start-${directory}"
printf "\e[34m[\e[32m*\e[34m]\e[36m Uninstall finished.\e[0m\n\n"
