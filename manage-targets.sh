#!/bin/bash

ACTION=$1
URL=$2
ENV=${3:-production}
TARGET_FILE="targets/targets.yml"

case $ACTION in
    "list")
        if [ -f "$TARGET_FILE" ]; then
            cat "$TARGET_FILE"
        else
            echo "No targets.yml found."
        fi
        ;;
    "add")
        if [ -z "$URL" ]; then
            echo "Error: URL is required for 'add' action."
            exit 1
        fi
        
        printf "\n- targets:\n    - %s\n  labels:\n    env: %s\n" "$URL" "$ENV" >> "$TARGET_FILE"
        echo "Successfully added $URL to $TARGET_FILE"
        ;;
    "remove")
        if [ -z "$URL" ]; then
            echo "Error: URL is required for 'remove' action."
            exit 1
        fi
        
        if [ ! -f "$TARGET_FILE" ]; then
            echo "Error: $TARGET_FILE not found."
            exit 1
        fi

        # Create a temporary file
        TEMP_FILE=$(mktemp)
        
        # Use awk to remove the block. This is a bit more robust for YAML blocks.
        # It looks for the start of a block and checks if the next line contains the URL.
        awk -v url="$URL" -v env="$ENV" '
            BEGIN { RS = ""; FS = "\n" }
            {
                match_url = 0
                match_env = 0
                for (i=1; i<=NF; i++) {
                    if ($i ~ "- "url) match_url = 1
                    if ($i ~ "env: "env) match_env = 1
                }
                if (!(match_url && match_env)) {
                    printf "%s%s", (first ? "\n\n" : ""), $0
                    first = 1
                }
            }
        ' "$TARGET_FILE" > "$TEMP_FILE"
        
        mv "$TEMP_FILE" "$TARGET_FILE"
        echo "Successfully removed $URL from $TARGET_FILE"
        ;;
    *)
        echo "Usage: $0 {add|remove|list} [URL] [ENV]"
        exit 1
        ;;
esac
