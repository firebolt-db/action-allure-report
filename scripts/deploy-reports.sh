#!/bin/bash
set -e

cd "$PAGES_BRANCH"
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

git config merge.renamelimit 0
git config diff.renames false

cp -rv ../$REPORT_FOLDER/* .

git add .

if git diff-index --quiet HEAD; then
  echo "Skipping. No new report changes found."
  exit 0
fi

git commit -m "chore: deploy Allure report: ${SHA}"

ATTEMPT=1
SLEEP_TIME=2
PUSH_URL="https://x-access-token:${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

until git pull --rebase -X ours "$PUSH_URL" "$PAGES_BRANCH"; do
  if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
    echo "Error: Max retries ($MAX_ATTEMPTS) reached after rebase conflicts."
    exit 1
  fi

  echo "Conflict during rebase. Retrying $ATTEMPT/$MAX_ATTEMPTS..."
  git rebase --abort || true

  # Wait (Exponential Backoff)
  sleep $SLEEP_TIME
  SLEEP_TIME=$((SLEEP_TIME * 2))
  ATTEMPT=$((ATTEMPT + 1))

  # Fetch latest changes again before retrying
  git fetch "$PUSH_URL" "$PAGES_BRANCH"
done

git push "$PUSH_URL" "$PAGES_BRANCH"
