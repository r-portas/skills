#!/bin/bash
# Reads PostToolUse hook input from stdin and formats the touched file if it's markdown.
INPUT=$(cat)
FILE_PATH=$(jq -r '.tool_input.file_path // empty' <<< "$INPUT")

# Only format markdown files
if [[ "$FILE_PATH" != *.md ]]; then
  exit 0
fi

"$CLAUDE_PROJECT_DIR/node_modules/.bin/oxfmt" "$FILE_PATH" >/dev/null 2>&1 || true
exit 0
