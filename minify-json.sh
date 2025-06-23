#!/bin/bash

set -e

# Usage check
[[ -z "$1" ]] && echo "Usage: $0 <json-file>" && exit 1

file="$1"

# File check
[[ ! -f "$file" ]] && echo "Error: File '$file' not found." && exit 1

# Check for jq
command -v jq >/dev/null || { echo "Error: jq is not installed."; exit 1; }

# Get file size (Linux/macOS compatible)
get_size() {
  stat -c %s "$1" 2>/dev/null || stat -f %z "$1"
}

before=$(get_size "$file")

# Minify
jq -c . "$file" > "$file.tmp" && mv "$file.tmp" "$file"

after=$(get_size "$file")
echo "Minified '$file': $before → $after bytes (saved $((before - after)) bytes)"
