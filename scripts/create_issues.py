#!/usr/bin/env python3
"""Bulk-create GitHub issues from issues.json using the gh CLI.

Usage:
    python create_issues.py                    # creates all issues
    python create_issues.py --dry-run          # prints what would be created, does not call gh
    python create_issues.py --from 1 --to 26   # creates issues 1..26 only (Sprint 0)
    python create_issues.py --milestone "M1 - Foundation"   # creates only M1 issues

Prerequisites:
    - gh CLI installed and authenticated (`gh auth status`)
    - Labels created (run setup_labels.sh first)
    - Milestones created (run setup_milestones.sh first)
    - You are inside the target repo folder (or set GH_REPO env var)
"""
import argparse
import json
import subprocess
import sys
import time
from pathlib import Path


def create_issue(issue: dict, dry_run: bool = False) -> bool:
    labels = ",".join(issue["labels"])
    cmd = [
        "gh",
        "issue",
        "create",
        "--title",
        issue["title"],
        "--body",
        issue["body"],
        "--label",
        labels,
        "--milestone",
        issue["milestone"],
        "--assignee",
        issue["assignee"],
    ]
    print(f"[{issue['number']:03d}] {issue['title']}")
    if dry_run:
        print(
            f"       DRY RUN — would assign to {issue['assignee']}, milestone '{issue['milestone']}'"
        )
        return True

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"       ERROR: {result.stderr.strip()}")
        return False
    print(f"       -> {result.stdout.strip()}")
    return True


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "--file",
        default="scripts/issues.json",
        help="Path to issues.json (default: scripts/issues.json)",
    )
    parser.add_argument(
        "--dry-run", action="store_true", help="Print what would be created without calling gh"
    )
    parser.add_argument(
        "--from", dest="from_num", type=int, default=1, help="Start issue number (inclusive)"
    )
    parser.add_argument(
        "--to", dest="to_num", type=int, default=999, help="End issue number (inclusive)"
    )
    parser.add_argument("--milestone", help="Only create issues in this milestone")
    parser.add_argument(
        "--sleep", type=float, default=1.0, help="Seconds between API calls (rate-limit safety)"
    )
    args = parser.parse_args()

    path = Path(args.file)
    if not path.exists():
        print(f"ERROR: {path} not found. Are you in the repo root?")
        sys.exit(1)

    all_issues = json.loads(path.read_text())
    selected = [
        i
        for i in all_issues
        if args.from_num <= i["number"] <= args.to_num
        and (args.milestone is None or i["milestone"] == args.milestone)
    ]

    print(f"About to create {len(selected)} of {len(all_issues)} total issues.")
    if args.dry_run:
        print("(DRY RUN — no gh calls will be made)")
    else:
        confirm = input("Proceed? [y/N] ").strip().lower()
        if confirm != "y":
            print("Aborted.")
            sys.exit(0)

    ok = 0
    failed = 0
    for issue in selected:
        if create_issue(issue, dry_run=args.dry_run):
            ok += 1
        else:
            failed += 1
        if not args.dry_run:
            time.sleep(args.sleep)

    print()
    print(f"Done. Created: {ok}, Failed: {failed}")
    if failed:
        print("Re-run with --from <first-failed-number> to retry.")
        sys.exit(1)


if __name__ == "__main__":
    main()
