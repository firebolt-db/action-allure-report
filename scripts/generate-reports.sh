#!/bin/bash
set -e

# Create a temp file to store URLs
echo "{}" > urls.json

echo "$MAPPING_JSON" | jq -r 'to_entries | .[] | "\(.key) \(.value)"' | while read -r src suffix; do
  if [ -d "$src" ]; then
    echo "Generating report: $src -> ${REPORT_DEST_BASE}_${suffix}"
    allure generate "$src" -o "${REPORT_DEST_BASE}_${suffix}"

    # Build URL and update the temp JSON file
    FINAL_URL="${REPORT_URL_BASE}_${suffix}"
    jq --arg k "$suffix" --arg v "$FINAL_URL" '. + {($k): $v}' urls.json > urls.tmp && mv urls.tmp urls.json
  else
    echo "⚠️ Skipping: Directory '$src' not found."
  fi
done
echo "urls=$(cat urls.json | jq -c .)" >> $GITHUB_OUTPUT
