---
name: react-style-guide
description: >
  Roy's React codestyle and conventions for TanStack Start, shadcn/ui, and
  Tailwind v4 projects. Consult this skill whenever writing, editing,
  refactoring, or reviewing React components, JSX, TypeScript props, event
  handlers, or deciding where to place files. When in doubt, match existing
  conventions rather than introducing new ones.
user-invocable: false
metadata:
  author: r-portas
---

# React Style Guide

## Components

### Naming and file conventions

File names use lowercase with hyphens: `search-input.tsx`, `page-header.tsx`, `post-card.tsx`. Component functions use PascalCase: `SearchInput`, `PageHeader`, `PostCard`. These always match — a file named `page-header.tsx` exports `PageHeader`.

The main component in a file uses a default export. Sub-components and everything else use named exports.

### Component location

| Location | What goes there |
| --- | --- |
| `src/components/ui/` | Base UI primitives (button, card, input, typography), following shadcn/ui conventions |
| `src/components/<domain>/` | Domain-specific groupings (e.g. `home/`, `posts/`) |
| `src/components/` | Shared components used across multiple routes |
| `src/hooks/` | Custom React hooks |
| `src/lib/` | Non-UI code: data fetching, utilities, etc. |

### Props typing

Use `interface` for component props, `type` for data structures:

```tsx
// ✅ Props use interface
interface PageHeaderProps {
  title: React.ReactNode;
  lead?: React.ReactNode;
  actions?: React.ReactNode;
}

// ✅ Data shapes use type
type PostSummary = {
  slug: string;
  title: string;
  date: string;
  tags: string[];
};
```

Always use the `type` keyword for type-only imports:

```tsx
import type { PostSummary } from "@/lib/posts";
import { type VariantProps } from "class-variance-authority";
```

### Component splitting

Extract a component when it manages its own state, has its own loading/error state, or can be described independently. Keep things inline otherwise — prefer fewer files.

If an extracted component is only used in one place, keep it in the same file as the parent rather than creating a new file.

### File structure

Only add regions when a file has more than one logical part. A file with a single component needs no regions at all:

```tsx
// simple-badge.tsx — single component, no regions needed
interface SimpleBadgeProps {
  label: string;
}

export default function SimpleBadge({ label }: SimpleBadgeProps) {
  return <span className="rounded px-2 py-0.5 text-xs">{label}</span>;
}
```

When a file has multiple parts, use `// #region <description>` / `// #endregion` blocks in this order:

1. **Types** — shared data types used across the file
2. **Helpers** — private utility functions only used within this file
3. **Main export** — the primary component (props interface lives inside this region)
4. **Sub-components** — co-located components (each gets its own region, props interface inside)

```tsx
// post-card.tsx

// #region Types
type PostSummary = { slug: string; title: string };
// #endregion

// #region Helpers
function groupPostsByYear(posts: PostSummary[]) {
  const groups: { year: number; posts: PostSummary[] }[] = [];
  for (const post of posts) {
    const year = new Date(post.date).getFullYear();
    const last = groups[groups.length - 1];
    if (last?.year === year) last.posts.push(post);
    else groups.push({ year, posts: [post] });
  }
  return groups;
}
// #endregion

// #region PostCard
interface PostCardProps {
  post: PostSummary;
  className?: string;
}

export default function PostCard({ post, className }: PostCardProps) {
  return <article className={cn("rounded-lg", className)}>...</article>;
}
// #endregion

// #region PostCardMeta
interface PostCardMetaProps {
  date: string;
  tags: string[];
}

function PostCardMeta({ date, tags }: PostCardMetaProps) {
  return <footer>...</footer>;
}
// #endregion
```

### Hooks

Custom hooks live in `src/hooks/`, named with the `use` prefix:

```ts
// src/hooks/use-local-storage.ts
export function useLocalStorage<T>(key: string, initial: T) { ... }
```

Extract logic into a hook when a component has non-trivial stateful behavior that could be named and described on its own, or when the same stateful logic appears in more than one component.

## Classnames

Use `cn()` (from `@/lib/utils`) to compose Tailwind classes. Don't use string interpolation or manual ternaries for class composition:

```tsx
// ✅
<div className={cn("rounded-lg p-4", isActive && "bg-primary", className)} />

// ❌
<div className={`rounded-lg p-4 ${isActive ? "bg-primary" : ""}`} />
```

Always accept and forward a `className` prop on presentational components so callers can extend styles.

## Import ordering

Import order is enforced automatically by oxfmt — don't manually sort or group imports.

## JSX style

Self-close elements with no children:

```tsx
// ✅
<Input />
<Separator />

// ❌
<Input></Input>
```

Conditional rendering patterns:

```tsx
// Optional slot — logical AND
{lead && <Lead>{lead}</Lead>}

// Binary state — ternary
{isLoading ? <Spinner /> : <Content />}

// Guard — early return
if (posts.length === 0) return null;
```

## Documentation

### Components

Default exported components get a TSDoc comment describing what the component does. Each field on the props interface gets an inline comment:

```tsx
/**
 * Displays a post summary card with title, date, and tag list.
 */
export default function PostCard({ post, className }: PostCardProps) {
  return <article className={cn("rounded-lg", className)}>...</article>;
}

interface PostCardProps {
  /** The post data to display. */
  post: PostSummary;
  /** Extra Tailwind classes forwarded to the root element. */
  className?: string;
}
```

The component TSDoc should describe what the component renders or does — not restate the component name. One sentence is usually enough. Prop comments can be brief phrases; omit them only when the prop name is completely self-explanatory (rare).

### Library helpers

Exported functions under `src/lib/` get a TSDoc comment with a brief `@example` block:

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

The `@example` should show a realistic call and, where non-obvious, the shape of the return value. Keep it short — two or three lines at most. Skip `@param` and `@returns` tags unless the types aren't self-documenting.

## Event handlers

Name handlers `handle` + action: `handleCopy`, `handleSubmit`, `handleSelect`. For simple inline handlers (analytics calls, single setState), inline is fine:

```tsx
<button onClick={handleCopy}>Copy</button>

<button onClick={() => capture("share_clicked", { slug })}>Share</button>
```

## Before finishing

After writing or editing any component, verify each item before reporting the task as done:

- [ ] Regions used if file has more than one logical part (Helpers → Main export → Sub-components)
- [ ] Default exported component has a TSDoc comment
- [ ] Every prop on the interface has an inline comment
- [ ] `cn()` used for all class composition (no string interpolation or manual ternaries)
- [ ] `type` keyword on all type-only imports
- [ ] Presentational components accept and forward a `className` prop
