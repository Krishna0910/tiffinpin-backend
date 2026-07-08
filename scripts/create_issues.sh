#!/bin/bash
set -e

CSV_FILE="${1:-scripts/issues.csv}"

if [ ! -f "$CSV_FILE" ]; then
  echo "CSV file not found: $CSV_FILE"
  exit 1
fi

# Skip header, then loop
tail -n +2 "$CSV_FILE" | while IFS=',' read -r number title body labels milestone assignee; do
  # Strip surrounding quotes
  title="${title%\"}"; title="${title#\"}"
  body="${body%\"}"; body="${body#\"}"
  labels="${labels%\"}"; labels="${labels#\"}"
  milestone="${milestone%\"}"; milestone="${milestone#\"}"
  assignee="${assignee%\"}"; assignee="${assignee#\"}"
  
  echo "Creating issue #$number: $title"
  
  gh issue create \
    --title "#$number · $title" \
    --body "$body" \
    --label "$labels" \
    --milestone "$milestone" \
    --assignee "$assignee"
  
  # Rate-limit safety
  sleep 1
done

echo "All issues created."