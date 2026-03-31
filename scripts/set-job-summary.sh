#!/bin/bash
set -e

echo "### Test Reports" >> "$GITHUB_STEP_SUMMARY"
echo "$URLS_JSON" | jq -r 'to_entries | .[] | "\(.key) \(.value)"' | while read -r name url; do
  echo "* [Report: $name]($url)" >> "$GITHUB_STEP_SUMMARY"
done
