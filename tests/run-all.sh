#!/usr/bin/env bash
# Runs every check-*.sh in this directory. Exit status is non-zero if any fails.
set -uo pipefail
cd "$(dirname "$0")"
status=0
for check in check-*.sh; do
  bash "$check" || status=1
done
exit $status
