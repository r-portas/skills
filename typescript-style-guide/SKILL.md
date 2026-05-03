---
name: typescript-style-guide
description: >
  Roy's TypeScript conventions — interface vs type, type-only imports, TSDoc,
  file naming, and region blocks. Consult whenever writing, editing, or
  reviewing any TypeScript or TSX file.
user-invocable: false
metadata:
  author: r-portas
---

# TypeScript Style Guide

## interface vs type

Use `interface` for object shapes. Use `type` for unions, aliases, and derived types.

## Type-only imports

Always use the `type` keyword for imports that are only used as types. This keeps intent explicit and ensures they're erased at compile time. → [example](references/examples.md#type-only-imports)

## File naming

Files use lowercase with hyphens: `user-profile.ts`, `date-utils.ts`, `post-card.tsx`. Never camelCase or PascalCase for file names.

## Region blocks

Use `// #region <description>` / `// #endregion` to organize files with more than one logical part. A single-export file needs no regions.

Typical ordering: **Types → Helpers → Main export** → [example](references/examples.md#region-blocks)

## TSDoc for exported functions

All exported functions get a TSDoc comment with a brief `@example`. Show a realistic call and, where non-obvious, the shape of the return value. Two or three lines max. Skip `@param` and `@returns` unless the types aren't self-documenting. → [example](references/examples.md#tsdoc-for-exported-functions)
