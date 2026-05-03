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

Use `interface` for object shapes. Use `type` for unions, aliases, and derived types:

```ts
// ✅ Object shape → interface
interface User {
  id: string;
  name: string;
}

// ✅ Union or alias → type
type Status = "active" | "inactive";
type UserId = string;
```

## Type-only imports

Always use the `type` keyword for imports that are only used as types. This keeps intent explicit and ensures they're erased at compile time:

```ts
import type { User } from "@/lib/users";
import { type VariantProps } from "class-variance-authority";
```

## File naming

Files use lowercase with hyphens: `user-profile.ts`, `date-utils.ts`, `post-card.tsx`. Never camelCase or PascalCase for file names.

## Region blocks

Use `// #region <description>` / `// #endregion` to organize files with more than one logical part. A single-export file needs no regions.

Typical ordering: **Types → Helpers → Main export**

```ts
// #region Types
interface PostSummary { slug: string; title: string }
// #endregion

// #region Helpers
function slugify(title: string): string { ... }
// #endregion

// #region Main export
export function formatPost(post: PostSummary) { ... }
// #endregion
```

## TSDoc for exported functions

All exported functions get a TSDoc comment with a brief `@example`:

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

Show a realistic call and, where non-obvious, the shape of the return value. Two or three lines max. Skip `@param` and `@returns` unless the types aren't self-documenting.

## Import ordering

Enforced automatically by oxfmt — don't manually sort or group imports.
