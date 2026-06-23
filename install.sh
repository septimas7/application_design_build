#!/usr/bin/env bash
# Install the Design & Build Skills into Claude Code or OpenAI Codex.
# Usage: ./install.sh <claude|codex> <personal|project> [project_path]
set -euo pipefail

PLATFORM="${1:-}"
SCOPE="${2:-}"
PROJECT_PATH="${3:-$(pwd)}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$PLATFORM" != "claude" && "$PLATFORM" != "codex" ]]; then
  echo "Usage: ./install.sh <claude|codex> <personal|project> [project_path]" >&2; exit 1
fi
if [[ "$SCOPE" != "personal" && "$SCOPE" != "project" ]]; then
  echo "Usage: ./install.sh <claude|codex> <personal|project> [project_path]" >&2; exit 1
fi

DIRNAME=$([[ "$PLATFORM" == "claude" ]] && echo ".claude" || echo ".codex")
BASE=$([[ "$SCOPE" == "personal" ]] && echo "$HOME" || echo "$PROJECT_PATH")
TARGET="$BASE/$DIRNAME/skills"

echo "Installing Design & Build Skills -> $TARGET"
mkdir -p "$TARGET"
cp -R "$SRC"/skills/* "$TARGET"/
mkdir -p "$TARGET/references"
cp -R "$SRC"/references/* "$TARGET/references"/

COUNT=$(find "$TARGET" -mindepth 1 -maxdepth 1 -type d ! -name references | wc -l | tr -d ' ')
echo "Installed $COUNT skills + references."
echo "Restart $PLATFORM to load them."
