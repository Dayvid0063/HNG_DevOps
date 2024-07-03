#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

input_file="$1"
log_file="/var/log/user_management.log"
password_file="/var/secure/user_passwords.csv"

# Ensure log and password directories exist and are secure
mkdir -p /var/log /var/secure
touch "$log_file" "$password_file"
chmod 600 "$password_file"

# Function to generate random password
generate_password() {
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 12
}

# Read input file line by line
while IFS=';' read -r username groups || [ -n "$username" ]; do
    username=$(echo "$username" | xargs)
    groups=$(echo "$groups" | xargs)

    # Create personal group if it doesn't exist
    if ! getent group "$username" >/dev/null; then
        groupadd "$username"
        echo "$(date): Group $username created" >> "$log_file"
    else
        echo "$(date): Group $username already exists" >> "$log_file"
    fi

    # Create user if it doesn't exist
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m -g "$username" "$username"
        echo "$(date): User $username created" >> "$log_file"
    else
        echo "$(date): User $username already exists" >> "$log_file"
    fi

    # Add user to additional groups
    IFS=',' read -ra group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        group=$(echo "$group" | xargs)
        if ! getent group "$group" >/dev/null; then
            groupadd "$group"
            echo "$(date): Group $group created" >> "$log_file"
        fi
        usermod -aG "$group" "$username"
        echo "$(date): User $username added to group $group" >> "$log_file"
    done

    # Generate and store password
    password=$(generate_password)
    echo "$username,$password" >> "$password_file"
    echo "$(date): Password for user $username generated and stored" >> "$log_file"

done < "$input_file"

echo "User creation process completed. Check $log_file for details."
