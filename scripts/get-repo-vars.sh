#!/bin/bash
set -e

base_url=$(gh api "repos/$GITHUB_REPOSITORY/pages" --jq '.html_url')
repository_name=$(echo "$GITHUB_REPOSITORY" | cut -d '/' -f 2)
echo "repo_url=${base_url}" >> "$GITHUB_OUTPUT"
echo "repo_name=${repository_name}" >> "$GITHUB_OUTPUT"

if [ -z "${PROVIDED_REPORT_PATH}" ]; then
  echo "report_path=allure/${repository_name}_${GITHUB_SHA}" >> "$GITHUB_OUTPUT"
else
  echo "report_path=${PROVIDED_REPORT_PATH}" >> "$GITHUB_OUTPUT"
fi
