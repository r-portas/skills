# React Style Guide — Examples

## Props typing

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

## File structure (regions)

```tsx
// post-card.tsx

// #region Types
interface PostSummary { slug: string; title: string }
// #endregion

// #region Helpers
function groupPostsByYear(posts: PostSummary[]) { ... }
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

## JSX conditional rendering

```tsx
// Optional slot — logical AND
{lead && <Lead>{lead}</Lead>}

// Binary state — ternary
{isLoading ? <Spinner /> : <Content />}

// Guard — early return
if (posts.length === 0) return null;
```

## Component documentation

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

```tsx
<button onClick={handleCopy}>Copy</button>
<button onClick={() => capture("share_clicked", { slug })}>Share</button>
```
