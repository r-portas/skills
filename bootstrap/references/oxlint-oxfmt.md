# oxfmt + oxlint Setup

oxfmt and oxlint are always configured together — oxfmt for formatting, oxlint for linting.

## Steps

### 1. Install as dev dependencies

```bash
bun add -D oxfmt oxlint
```

### 2. Add scripts to `package.json`

```json
{
  "scripts": {
    "format": "oxfmt .",
    "lint": "oxlint ."
  }
}
```

### 3. Create config files

`.oxfmtrc.json`:

```json
{
  "$schema": "./node_modules/oxfmt/configuration_schema.json",
  "experimentalSortImports": {},
  "experimentalTailwindcss": {}
}
```

> Remove `experimentalTailwindcss` if the project doesn't use Tailwind CSS.

`.oxlintrc.json`:

```json
{
  "$schema": "./node_modules/oxlint/configuration_schema.json",
  "plugins": ["eslint", "jsdoc", "react", "react-perf", "nextjs"]
}
```

> Remove the `nextjs` plugin if the project doesn't use Next.js.

### 4. VS Code setup

`.vscode/extensions.json`:

```json
{
  "recommendations": ["oxc.oxc-vscode"]
}
```

`.vscode/settings.json`:

```json
{
  "editor.defaultFormatter": "oxc.oxc-vscode",
  "editor.formatOnSave": true
}
```

### 5. Auto-format on save with a Claude hook

A `PostToolUse` hook formats files with oxfmt every time Claude writes or edits one.

`.claude/hooks/format.sh` (make it executable with `chmod +x`):

```bash
#!/bin/bash
# Reads PostToolUse hook input from stdin and formats the touched file with oxfmt.
INPUT=$(cat)
FILE_PATH=$(jq -r '.tool_input.file_path // empty' <<< "$INPUT")

[[ -z "$FILE_PATH" ]] && exit 0

"$CLAUDE_PROJECT_DIR/node_modules/.bin/oxfmt" "$FILE_PATH" >/dev/null 2>&1 || true
exit 0
```

`.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/format.sh",
            "statusMessage": "Formatting..."
          }
        ]
      }
    ]
  }
}
```

> oxfmt ignores files it doesn't support, so the hook can run on every edit without filtering by extension.

### 6. Verify

```bash
bun run format
bun run lint
```

### 7. Remove old Prettier / ESLint

- Delete config files: `.prettierrc`, `.eslintrc`, `eslint.config.*`, etc.
- Remove packages: `prettier`, `eslint`, and related plugins from `package.json`
- Run `bun install` to clean up `node_modules`
