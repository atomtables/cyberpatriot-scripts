#!/bin/bash

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
    fi
done

# Check for users with admin privileges (assumed to have sudo access)
for USER in "${EXPECTED_USERS[@]}"; do
    if id -u "$USER" >/dev/null 2>&1; then
        if sudo -lU "$USER" | grep -q "(ALL:ALL)"; then
            echo "User '${USER}' has admin privileges."
        fi
    fi
done
