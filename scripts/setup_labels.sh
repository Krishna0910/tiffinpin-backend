#!/bin/bash
set -e

# Delete GitHub's default labels (optional — cleaner slate)
gh label delete "bug" --yes 2>/dev/null || true
gh label delete "documentation" --yes 2>/dev/null || true
gh label delete "duplicate" --yes 2>/dev/null || true
gh label delete "enhancement" --yes 2>/dev/null || true
gh label delete "good first issue" --yes 2>/dev/null || true
gh label delete "help wanted" --yes 2>/dev/null || true
gh label delete "invalid" --yes 2>/dev/null || true
gh label delete "question" --yes 2>/dev/null || true
gh label delete "wontfix" --yes 2>/dev/null || true

# Type labels
gh label create "feature"       --color "0E8A16" --description "New feature or capability"
gh label create "bug"           --color "D73A4A" --description "Something broken"
gh label create "enhancement"   --color "A2EEEF" --description "Improvement to existing feature"
gh label create "refactor"      --color "FBCA04" --description "Code restructure, no behavior change"
gh label create "documentation" --color "0075CA" --description "Docs only"
gh label create "testing"       --color "BFD4F2" --description "Tests only"
gh label create "chore"         --color "CFD3D7" --description "Tooling, config, meta"
gh label create "spike"         --color "D4C5F9" --description "Time-boxed research"

# Area labels
gh label create "backend"       --color "1D76DB" --description "Backend code"
gh label create "database"      --color "5319E7" --description "Database/schema/migrations"
gh label create "api"           --color "006B75" --description "API endpoints, contracts"
gh label create "auth"          --color "B60205" --description "Authentication"
gh label create "payments"      --color "FBCA04" --description "Payments, wallet"
gh label create "orders"        --color "F9D0C4" --description "Order lifecycle"
gh label create "vendor"        --color "C5DEF5" --description "Vendor features"
gh label create "admin"         --color "BFDADC" --description "Admin features"
gh label create "search"        --color "D4C5F9" --description "Search, filters, discovery"
gh label create "notifications" --color "FEF2C0" --description "Notifications, emails"
gh label create "infra"         --color "0052CC" --description "Infra, Docker, deploy"
gh label create "ci-cd"         --color "1D76DB" --description "CI/CD pipelines"
gh label create "security"      --color "B60205" --description "Security concerns"

# Priority labels
gh label create "P0-critical"   --color "B60205" --description "Blocker, drop everything"
gh label create "P1-high"       --color "D93F0B" --description "High priority"
gh label create "P2-medium"     --color "FBCA04" --description "Medium priority"
gh label create "P3-low"        --color "0E8A16" --description "Low priority"

# Meta labels
gh label create "blocked"           --color "000000" --description "Waiting on something"
gh label create "needs-discussion"  --color "D876E3" --description "Needs alignment"
gh label create "good first issue"  --color "7057FF" --description "Easy pickup"
gh label create "tech-debt"         --color "CFD3D7" --description "Debt to pay down"
gh label create "breaking-change"   --color "B60205" --description "Breaks API contract"

# Effort labels
gh label create "size:XS"       --color "C2E0C6" --description "<1 hour"
gh label create "size:S"        --color "C2E0C6" --description "1-2 hours"
gh label create "size:M"        --color "FBCA04" --description "2-4 hours"
gh label create "size:L"        --color "D93F0B" --description ">4 hours — consider splitting"

echo "Labels created successfully."
