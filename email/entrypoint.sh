#!/usr/bin/env sh

set -e
set -o xtrace

echo "Executing email action..."
ls -l /actions
whoami

exec /actions/email