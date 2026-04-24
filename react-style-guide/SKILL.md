---
name: react-style-guide
description: >
  Roy's React codestyle and conventions for TanStack Start, shadcn/ui, and
  Tailwind v4 projects. Consult this skill whenever writing, editing, or
  reviewing React components, JSX, TypeScript props, event handlers, or
  deciding where to place files. When in doubt, match existing conventions
  rather than introducing new ones.
user-invocable: false
---

# React Style Guide

## Components

### Naming and file conventions

File names use lowercase with hyphens: `search-input.tsx`, `page-header.tsx`, `post-card.tsx`. Component functions use PascalCase: `SearchInput`, `PageHeader`, `PostCard`. These always match — a file named `page-header.tsx` exports `PageHeader`.

Use named exports everywhere. No default exports except in `src/components/ui/` where shadcn generates them.

### Component location

| Location | What goes there |
| --- | --- |
| `src/components/ui/` | Base UI primitives (button, card, input, typography), following shadcn/ui conventions |
| `src/components/<domain>/` | Domain-specific groupings (e.g. `home/`, `posts/`) |
| `src/components/` | Shared components used across multiple routes |
| `src/lib/` | Non-UI code: data fetching, utilities, hooks, etc. |

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

## Event handlers

Name handlers `handle` + action: `handleCopy`, `handleSubmit`, `handleSelect`. For simple inline handlers (analytics calls, single setState), inline is fine:

```tsx
<button onClick={handleCopy}>Copy</button>

<button onClick={() => capture("share_clicked", { slug })}>Share</button>
```
