---
name: bootstrap
description: >
  Installs and fully integrates packages and libraries into a project — including
  config files, helper modules, and scaffolded templates. Use when the user asks
  to install, set up, configure, add, or bootstrap a specific package: drizzle,
  date-fns, oxlint, oxfmt or similar. Prefer this over a generic npm install
  whenever the package has an opinionated setup or requires boilerplate files.
metadata:
  author: r-portas
---

# Bootstrap

Fully integrate a package into the current project — not just `npm install`, but
config files, wrapper modules, and any scaffolded boilerplate.

## Steps

1. Identify which package is being bootstrapped from the user's request
2. **Read the reference file** using the `Read` tool before writing any code — do not rely on memory or training data
3. Follow the reference file's instructions exactly
4. If no reference file exists for the requested package, use best judgement and follow the general conventions of the codebase

## Packages

| Package | Reference |
| --- | --- |
| drizzle | [references/drizzle.md](references/drizzle.md) |
| date-fns | [references/date-fns.md](references/date-fns.md) |
| oxlint + oxfmt | [references/oxlint-oxfmt.md](references/oxlint-oxfmt.md) |
