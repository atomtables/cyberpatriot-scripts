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

# Read expected users from user input until an empty line is entered
echo "Enter the expected users, one per line. Press Enter on an empty line when finished:"
EXPECTED_USERS=()
while read -r USER && [ -n "$USER" ]; do
    EXPECTED_USERS+=("$USER")
done

# Get a list of local users on the system
ALL_USERS=($(cat /etc/passwd | grep '/home' | cut -d: -f1))

# Check for unexpected users
for USER in "${ALL_USERS[@]}"; do
    if [[ ! " ${EXPECTED_USERS[@]} " =~ " ${USER} " ]]; then
        echo "User '${USER}' is not in the expected list."
	read -p "Delete user? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || none
	./deleteuser.sh "${USER}"
    fi
done

# Check for users with admin privileges (assumed to have sudo access)
for USER in "${EXPECTED_USERS[@]}"; do
    if id -u "$USER" >/dev/null 2>&1; then
        if groups "$USER" | grep -q "\bsudo\b"; then
            echo "User '${USER}' has admin privileges. (under the sudo group)"
        fi
	if groups "$USER" | grep -q "\bwheel\b"; then
	    echo "User '${USER}' has admin privileges. (under the wheel group)"
	fi
    fi
done
