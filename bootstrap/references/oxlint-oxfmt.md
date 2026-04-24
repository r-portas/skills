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

### 5. Verify

```bash
bun run format
bun run lint
```

### 6. Remove old Prettier / ESLint

- Delete config files: `.prettierrc`, `.eslintrc`, `eslint.config.*`, etc.
- Remove packages: `prettier`, `eslint`, and related plugins from `package.json`
- Run `bun install` to clean up `node_modules`
