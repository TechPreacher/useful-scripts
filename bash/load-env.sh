#!/usr/bin/env bash

# This script reads the .env file line by line and exports the environment variables to the shell environment.

# Exit on error
set -e

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found"
    exit 1
fi

# Check if .env file is readable
if [ ! -r .env ]; then
    echo "Error: .env file is not readable"
    exit 1
fi

# Read .env file line by line
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    if [ -z "$line" ] || [[ $line == \#* ]]; then
        continue
    fi

    # Export the environment variable
    if [[ $line =~ ^[[:space:]]*([^[:space:]#=]+)[[:space:]]*=[[:space:]]*(.+)[[:space:]]*$ ]]; then
        key="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        # Remove surrounding quotes if they exist
        value="${value#[\"\']}"
        value="${value%[\"\']}"
        export "$key=$value"
        echo "Exported: $key = $value"
    else
        echo "Warning: Invalid line format: $line"
    fi
done < .env

echo "Environment variables loaded successfully"
