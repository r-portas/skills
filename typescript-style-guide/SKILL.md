---
name: typescript-style-guide
description: >
  Roy's TypeScript conventions — interface vs type, type-only imports, TSDoc,
  file naming, and region blocks. Consult whenever writing, editing, or
  reviewing any TypeScript or TSX file.
user-invocable: true
metadata:
  author: r-portas
---

# TypeScript Style Guide

## interface vs type

Use `interface` for object shapes. Use `type` for unions, aliases, and derived types.

## Type-only imports

Always use the `type` keyword for imports that are only used as types. This keeps intent explicit and ensures they're erased at compile time.

```ts
import type { User } from "@/lib/users";
import { type VariantProps } from "class-variance-authority";
```

## File naming

Files use lowercase with hyphens: `user-profile.ts`, `date-utils.ts`, `post-card.tsx`. Never camelCase or PascalCase for file names.

## Region blocks

Use `// #region <description>` / `// #endregion` to organize files with more than one logical part. A single-export file needs no regions.

**Co-locate types and helpers with the function that uses them** — place them inside the same region, above the function, not in a top-level `// #region types` block. A shared `// #region types` block is only appropriate when types are used across multiple regions in the file.

Typical region ordering — each region contains its own types/helpers followed by the exported function(s):

```ts
// #region path helpers
// (no special types needed here)
export function resolveComposePath(...) { … }
// #endregion

// #region parsing
type ParseResult = …          // ← type lives here, not at the top
export async function parse(...): Promise<ParseResult> { … }
// #endregion

// #region status
interface StatusResult { … }  // ← same region as its consumer
function rollUp(…) { … }      // ← private helpers above the export
export async function composeStatus(…): Promise<StatusResult> { … }
// #endregion
```

## null vs undefined

Prefer `undefined` over `null` for absent values. Use `undefined` in return types, optional fields, and fallback expressions. Avoid `null` unless interacting with an external API that requires it.

## TSDoc for exported functions

All exported functions get a TSDoc comment with a brief `@example`. Show a realistic call and, where non-obvious, the shape of the return value. Two or three lines max. Skip `@param` and `@returns` unless the types aren't self-documenting.

```ts
/**
 * Groups an array of posts by publication year, most recent first.
 *
 * @example
 * const grouped = groupPostsByYear(posts);
 * // [{ year: 2024, posts: [...] }, { year: 2023, posts: [...] }]
 */
export function groupPostsByYear(posts: PostSummary[]): YearGroup[] { ... }
```
