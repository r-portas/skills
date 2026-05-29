---
name: react-style-guide
description: >
  Roy's React conventions for shadcn/ui and Tailwind — component and file
  naming, props typing, region blocks, `cn()` class composition, conditional
  JSX, and TSDoc. Consult whenever writing, editing, or reviewing React
  components or JSX.
user-invocable: true
metadata:
  author: r-portas
---

# React Style Guide

For general TypeScript conventions (interface vs type, file naming, region blocks, TSDoc for utilities), see the `typescript-style-guide` skill.

## Components

### Naming and file conventions

File names use lowercase with hyphens: `search-input.tsx`, `page-header.tsx`. Component functions use PascalCase: `SearchInput`, `PageHeader`. These always match — a file named `page-header.tsx` exports `PageHeader`.

The main component in a file uses a default export. Sub-components and everything else use named exports.

### Component location

See `tanstack-start-project-structure` for the full directory layout.

### Props typing

Props and data shapes both use `interface` — see `typescript-style-guide` for when to reach for `type` instead.

```tsx
interface PageHeaderProps {
  title: React.ReactNode;
  lead?: React.ReactNode;
  actions?: React.ReactNode;
}

interface PostSummary {
  slug: string;
  title: string;
  date: string;
  tags: string[];
}
```

### Component splitting

Extract a component when it manages its own state, has its own loading/error state, or can be described independently. Keep things inline otherwise — prefer fewer files.

If an extracted component is only used in one place, keep it in the same file as the parent rather than creating a new file.

### File structure

Only add regions when a file has more than one logical part. A file with a single component needs no regions at all. When a file has multiple parts, follow the region ordering from `typescript-style-guide`: co-locate types and helpers with the region that uses them.

```tsx
// post-card.tsx

// #region PostCard
interface PostCardProps {
  /** The post data to display. */
  post: PostSummary;
  /** Extra Tailwind classes forwarded to the root element. */
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

## Classnames

Use `cn()` (from `@/lib/utils`) to compose Tailwind classes. Don't use string interpolation or manual ternaries for class composition. Always accept and forward a `className` prop on presentational components so callers can extend styles.

## JSX style

For conditional rendering, prefer logical AND for optional slots, ternary for binary states, and early return for guards.

```tsx
// Optional slot — logical AND
{lead && <Lead>{lead}</Lead>}

// Binary state — ternary
{isLoading ? <Spinner /> : <Content />}

// Guard — early return
if (posts.length === 0) return null;
```

## Documentation

Default exported components get a TSDoc comment. Each prop gets an inline comment. One sentence is enough. Prop comments can be brief phrases; omit only when the prop name is completely self-explanatory.

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

## Event handlers

Name handlers `handle` + action: `handleCopy`, `handleSubmit`, `handleSelect`. For simple inline handlers, inline is fine.

```tsx
<button onClick={handleCopy}>Copy</button>
<button onClick={() => capture("share_clicked", { slug })}>Share</button>
```

## Before finishing

After writing or editing any component, verify each item before reporting the task as done:

- [ ] Regions used if file has more than one logical part (Types → Helpers → Main export → Sub-components)
- [ ] Default exported component has a TSDoc comment
- [ ] Every prop on the interface has an inline comment
- [ ] `cn()` used for all class composition (no string interpolation or manual ternaries)
- [ ] `type` keyword on all type-only imports
- [ ] Presentational components accept and forward a `className` prop
