#!/bin/bash

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

echo -e "${CYAN}This script was brought to you by atomtables and swaroop for CPC under MCA/EAMS...${NC}"
read -t 5

echo -e "${MAGENTA}Package removal using blacklist will begin in 10 seconds. To skip, Ctrl+C...${NC}"
read -t 10

is_installed() {
    sudo dpkg -s "$1" &> /dev/null
    return $?
}

perform_action() {
    local action="$1"
    local package="$2"
    sudo apt-get "$action" "${package}*" &> /dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${action^}d package ${package}!${NC}"
    else
        echo -e "${RED}ERROR OCCURRED WHEN SYSTEM TRIED TO $action THIS PACKAGE: ${package}.${NC}"
    fi
}

readarray -t packageBlacklist < data/blacklist_of_pkgs.txt
declare -a badPackages

for package in "${packageBlacklist[@]}"; do
    if is_installed "$package"; then
        badPackages+=("$package")
        echo -e "${YELLOW}The package $package has been found!${NC}"
    else
        echo -e "${GREEN}The package $package was not found on the system.${NC}"
    fi
done

for package in "${badPackages[@]}"; do
    perform_action "remove" "$package"
    perform_action "purge" "$package"
    perform_action "autoremove" "$package"
done

echo "Blacklisted packages have been removed from the system."
