#!/bin/bash
set -e

# Map job status to GitHub Status API state
case "${JOB_STATUS}" in
  success) STATE="success" ;;
  failure) STATE="failure" ;;
  cancelled) STATE="error" ;;
  *) STATE="error" ;;
esac

# Parse the JSON output and loop through each name/url pair
echo "$URLS_JSON" | jq -r 'to_entries | .[] | "\(.key) \(.value)"' | while read -r name url; do
  echo "Setting status for $name..."

  curl -fsSL \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$API_URL" \
    -d "{
      \"state\": \"$STATE\",
      \"target_url\": \"$url\",
      \"description\": \"Click to access Allure report\",
      \"context\": \"Test Results ($name)\"
    }"
done
