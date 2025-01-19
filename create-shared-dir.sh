#!/bin/bash

echo "Script execution Started."
# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <absolute or relative path>"
    exit 1
fi

#Group for developers
GROUP="developers"

echo "Script execution complete."