#!/bin/bash

echo "Script execution Started."

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <absolute path>"
    exit 1
fi

# Define the group for developers
GROUP="developers"

# Check if the group 'developers' exists, create it if not
if ! getent group "$GROUP" > /dev/null; then
    echo "Group '$GROUP' does not exist. Creating it Group..."
    sudo groupadd "$GROUP"
fi

# Loop through all provided paths and create shared directories
for DIR in "$@"; do
    # Check parent directory exists
    PARENT_DIR=$(dirname "$DIR")
    if [ ! -d "$PARENT_DIR" ]; then
        echo "Parent directory '$PARENT_DIR' does not exist. Skipping '$DIR'."
        continue
    fi

    # Create the shared directory if it doesn't already exist
    if [ ! -d "$DIR" ]; then
        echo "Creating shared directory at '$DIR'..."
        sudo mkdir -p "$DIR"
    else
        echo "Directory '$DIR' already exists. Proceeding to set permissions."
    fi

    # Change the group of the directory to 'devs'
    sudo chown :$GROUP "$DIR"

    # SeSetting directory permissions so that the group can read/write
    sudo chmod 2770 "$DIR"  # rwxrwx--- for directories (setgid bit)

    # Set the setgid bit on the directory so new files inherit the group
    sudo chmod g+s "$DIR"

    echo "Shared directory '$DIR' has been set up with the following permissions:"
    ls -ld "$DIR"
done

echo "Script execution complete."