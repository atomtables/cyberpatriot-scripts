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

echo -e "${MAGENTA}Services removal using whitelist will begin in 10 seconds. To skip, Ctrl+C...${NC}"
read -t 10

sudo service --status-all > data/current_services.txt

awk -F']' '{print $2}' data/current_services.txt | tr -d '[:blank:]' > data/current_services.txt

mapfile -t whitelist_of_services < data/whitelist_of_services.txt

badServices=()

while IFS= read -r service; do
    if [[ ! " ${whitelist_of_services[*]} " =~ " $service " ]]; then
        badServices+=("$service")
    fi
done < data/current_services.txt

printf "%s\n" "${badServices[@]}" > data/badServices.txt

echo -e "---------------------------------"
echo "   Do you want to disable these services?"
echo "                (y/n)"
cat data/badServices.txt
echo -e "---------------------------------"

read -p 'y/n: ' YORN

if [[ "$YORN" == "y" ]]; then
    echo
else
    echo "edit the badServices file."
    exit 0
fi

for service in "${badServices[@]}"; do
    sudo systemctl disable "$service"
    echo -e "${RED}Disabled $service ${NC}"
done

echo -e "------------------"
echo "   Do you want to reverse this action?"
echo "                (y/n)"
echo -e "------------------"

read -p 'y/n: ' YORN

if [[ "$YORN" == "y" ]]; then
    for service in "${badServices[@]}"; do
        sudo systemctl enable "$service"
        echo -e "${GREEN}reenabled $service ${NC}"
        echo
        echo -e "${YELLOW}Finished reenabling services. this has been completely pointless btw${NC}"
    done
else
    echo
    echo -e "${GREEN}Completed services check.${NC}"
    echo
fi
