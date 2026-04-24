#!/usr/bin/env bash
# Usage: ./install.sh
#
# Symlinks all skills into the agent skills directories:
#   ~/.claude/skills/   — Claude Code
#   ~/.agents/skills/   — other agents
#
# Directories are created if they don't exist.
# Existing symlinks are left untouched. Non-symlink entries are skipped with a warning.
# Re-run whenever you add new skills.

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIRS=("$HOME/.claude/skills" "$HOME/.agents/skills")

# Symlink a single skill into a target directory
link_skill() {
  local name="$1"
  local skill="$2"
  local target_dir="$3"
  local target="$target_dir/$name"

  mkdir -p "$target_dir"

  if [ -L "$target" ]; then
    echo "already linked: $name → $target_dir"
  elif [ -e "$target" ]; then
    echo "skipping $name in $target_dir — exists and is not a symlink (remove it manually to link)"
  else
    ln -s "$skill" "$target"
    echo "linked: $name → $target_dir"
  fi
}

# Iterate over each skill directory and link it into all target directories
for skill in "$SKILLS_DIR"/*/; do
  name="$(basename "$skill")"
  for target_dir in "${TARGET_DIRS[@]}"; do
    link_skill "$name" "$skill" "$target_dir"
  done
done
