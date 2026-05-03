# TypeScript Style Guide — Examples

## Type-only imports

```ts
import type { User } from "@/lib/users";
import { type VariantProps } from "class-variance-authority";
```

## Region blocks

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
