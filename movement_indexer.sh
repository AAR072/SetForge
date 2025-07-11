#!/bin/bash

DIR="assets/exercises"
OUT_FILE="$DIR/index.json"

# List JSON files excluding index.json, get filenames only
files=$(find "$DIR" -maxdepth 1 -type f -iname "*.json" ! -name "index.json" | xargs -n 1 basename | awk '{printf "\"%s\",\n", $0}')

# Remove trailing comma and wrap with brackets
echo -e "[\n${files%,\n}\n]" > "$OUT_FILE"

echo "Created $OUT_FILE with list of JSON files."
