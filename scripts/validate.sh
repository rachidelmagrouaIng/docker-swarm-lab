#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v docker >/dev/null || { echo 'Docker CLI is required for stack validation.' >&2; exit 1; }
command -v python3 >/dev/null || { echo 'Python 3 is required.' >&2; exit 1; }
docker stack config --compose-file stack.yml >/dev/null
test "$(python3 examples/hello-python/hello.py)" = 'Hello, IRSI!'
echo 'Stack configuration and Python example checks passed. Live Swarm behavior is not tested.'
