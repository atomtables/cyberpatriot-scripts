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

read -p "${CYAN}This script was brought to you by atomtables and swaroop for CPC under MCA/EAMS...${NC}" -t 5

if [ -z "$1" ]; then
    echo "${RED}please enter a username that is valid to be completely deleted from the system.${NC}"
    exit
fi

userdel -fr "$1"
groupdel -f "$1"