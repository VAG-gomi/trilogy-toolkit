#!/usr/bin/env bash
# Trilogy toolkit installer — one command, no surprises.
# Creates an isolated venv (never touches system Python), installs the three
# pinned Trilogy software mirrors, and verifies the imports.
# Non-interactive: safe for humans and AI agents alike.
set -euo pipefail

VENV_DIR="${TRILOGY_VENV:-./trilogy-venv}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 not found on PATH." >&2
  exit 1
fi

PYV="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
echo "Using python3 ($PYV)"

# Some systems have a tiny /tmp (e.g. 512M tmpfs); keep pip's build
# workspace somewhere roomy.
export TMPDIR="${TMPDIR:-$SCRIPT_DIR/.pip-tmp}"
mkdir -p "$TMPDIR"

if [ ! -d "$VENV_DIR" ]; then
  echo "Creating venv at $VENV_DIR ..."
  python3 -m venv "$VENV_DIR"
else
  echo "Reusing existing venv at $VENV_DIR ..."
fi

"$VENV_DIR/bin/pip" install --quiet --upgrade pip
echo "Installing Trilogy packages (pinned commits) ..."
# --resume-retries: maf/cfhm pull torch (~526 MB); survive flaky networks.
"$VENV_DIR/bin/pip" install --resume-retries 10 -r "$SCRIPT_DIR/requirements.txt"

echo "Verifying ..."
"$VENV_DIR/bin/python" "$SCRIPT_DIR/verify.py"

echo
echo "Done. Activate with:"
echo "  source $VENV_DIR/bin/activate"
