#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.claude/skills"

mkdir -p "$TARGET_DIR"

for skill in "$SKILLS_DIR"/*/; do
  name="$(basename "$skill")"
  target="$TARGET_DIR/$name"

  if [ -L "$target" ]; then
    echo "already linked: $name"
  elif [ -e "$target" ]; then
    echo "skipping $name — $target exists and is not a symlink (remove it manually to link)"
  else
    ln -s "$skill" "$target"
    echo "linked: $name"
  fi
done
