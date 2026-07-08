#!/bin/bash
set -e

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

create_milestone() {
  local title=$1
  local description=$2
  local due_date=$3
  
  gh api "repos/$REPO/milestones" \
    -f title="$title" \
    -f description="$description" \
    -f due_on="$due_date" \
    -f state="open" > /dev/null
  echo "Created milestone: $title"
}

# Adjust dates based on your actual start. These assume start = 2026-07-07 (Monday)
create_milestone "M1 - Foundation" "Sprints 0-1: Repo, tooling, DB layer" "2026-08-04T23:59:59Z"
create_milestone "M2 - Identity & Access" "Sprints 2-3: Auth, RBAC, users, addresses" "2026-09-01T23:59:59Z"
create_milestone "M3 - Vendor Platform" "Sprints 4-6: Vendor onboarding, menu, delivery zones" "2026-10-13T23:59:59Z"
create_milestone "M4 - Ordering Engine" "Sprints 7-9: Cart, orders, payments" "2026-11-24T23:59:59Z"
create_milestone "M5 - Growth Features" "Sprints 10-11: Coupons, reviews, notifications, uploads" "2026-12-22T23:59:59Z"
create_milestone "M6 - Insights" "Sprint 12: Reports, dashboards" "2027-01-05T23:59:59Z"
create_milestone "M7 - Hardening" "Sprints 13-14: Security, tests, docs" "2027-02-02T23:59:59Z"
create_milestone "M8 - Production Launch" "Sprint 15: CI/CD, observability, deploy" "2027-02-16T23:59:59Z"

echo "Milestones created."
