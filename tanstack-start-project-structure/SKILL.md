---
name: tanstack-start-project-structure
description: >
  File layout and code-organization conventions for Roy's TanStack Start
  projects — where files live under `src/`, the `.functions.ts` /
  `.server.ts` / `.schema.ts` split for business logic, route and loader
  structure, and how the client/server boundary is enforced. Consult when
  creating any file under `src/`, adding or editing a route or loader,
  writing or modifying a `createServerFn` server function, or deciding
  where a piece of logic should live.
user-invocable: false
metadata:
  author: r-portas
---

# Project Structure

## Directory layout

| Path | What goes there |
| --- | --- |
| `src/router.tsx` | Router factory (`getRouter()`). Imports `routeTree.gen.ts` and creates the router instance. |
| `src/routes/` | TanStack Start file-based routes |
| `src/components/ui/` | Base UI primitives (shadcn/ui conventions) |
| `src/components/<domain>/` | Domain-specific component groupings (e.g. `home/`, `posts/`) |
| `src/components/` | Shared components used across multiple routes |
| `src/hooks/` | Custom React hooks |
| `src/lib/` | Non-UI utilities, data fetching, helpers |
| `src/db/` | Database client and schema (Drizzle) |
| `src/global.css` | shadcn theme variables and global CSS |
| `routeTree.gen.ts` | Auto-generated route tree — do not edit by hand. |

## src/routes/

TanStack Start uses file-based routing. Each file maps to a URL segment. Use folder-per-param when a dynamic segment has children; leave it flat when it's a leaf:

```
src/routes/
├── __root.tsx                    # Root layout (nav, providers, etc.)
├── index.tsx                     # /
├── about.tsx                     # /about — leaf route, flat
└── posts/
    ├── index.tsx                 # /posts
    └── $postId/
        ├── index.tsx             # /posts/:postId
        └── edit.tsx              # /posts/:postId/edit
```

Each route file exports a single `Route` constant from `createFileRoute`, plus an **unexported** component function:

```tsx
export const Route = createFileRoute("/posts/$postId/")({
  loader: ({ params }) => { ... },
  component: PostDetail,
});

function PostDetail() {  // unexported — preserves code splitting
  const data = Route.useLoaderData();
  const { postId } = Route.useParams();
  // ...
}
```

**CRITICAL: Never `export` component functions from route files.** Exported functions are included in the main bundle and bypass code splitting entirely. Keep component functions unexported.

**CRITICAL: Loaders are isomorphic — they run on both server and client.** Never put DB queries, secrets, or Node-only code directly in a loader. Always wrap server-only logic in `createServerFn` and call it from the loader.

### Loader composition (default pattern)

Compose data from multiple primitive `createServerFn`s in `src/lib/` via `Promise.all`:

```tsx
export const Route = createFileRoute("/authors/$authorSlug/")({
  loader: async ({ params }) => {
    const author = await getAuthor({ data: { slug: params.authorSlug } });
    if (!author) throw notFound();
    const [posts, recentComments] = await Promise.all([
      listPostsByAuthor({ data: { authorSlug: params.authorSlug } }),
      listRecentComments({ data: { authorSlug: params.authorSlug } }),
    ]);
    return { author, posts, recentComments };
  },
  component: AuthorPage,
});
```

### Route-coupled view fns (escape hatch)

When a view needs an initial fetch followed by several reads that all depend on its result, define a view-shaped `createServerFn` **in the route file itself** rather than in `src/lib/`. Co-location signals route-coupling — no reuse expected. The fn may import `.server.ts` helpers freely.

```tsx
// src/routes/posts/$postId/index.tsx
const getPostDetailView = createServerFn({ method: "GET" })
  .inputValidator(z.object({ postId: z.string() }))
  .handler(async ({ data }) => {
    const post = await findPostById(data.postId); // from posts.server.ts
    if (!post) throw new Error("Post not found");
    const [author, comments, related, reactions] = await Promise.all([
      findAuthorBySlug(post.authorSlug),
      listCommentsForPost(post.id),
      listRelatedPosts(post.tags),
      getReactionCounts(post.id),
    ]);
    return { post, author, comments, related, reactions };
  });

export const Route = createFileRoute("/posts/$postId/")({
  loader: ({ params }) => getPostDetailView({ data: { postId: params.postId } }),
  component: PostDetail,
});
```

Composing this from individual `createServerFn`s in the loader would refetch the post 4 times (once per dependent read). The route-local view fn fetches it once and shares it.

## src/db/

Two files live directly under `src/db/`:

- **`index.ts`** — the Drizzle client, imported wherever queries are run
- **`schema.ts`** — all table definitions

```
src/db/
├── index.ts    # export const db = drizzle(...)
└── schema.ts   # export const postsTable = sqliteTable(...)
```

**CRITICAL: Mark `db/index.ts` as server-only.** Add the server-only import at the top so any client-side import becomes a build error instead of a silent leak of the Drizzle client (and your DB connection) into the client bundle:

```ts
// src/db/index.ts
import "@tanstack/react-start/server-only";
import { drizzle } from "drizzle-orm/...";
// ...
export const db = drizzle(...);
```

`db` is then safe to use inside `createServerFn` handler bodies and `.server.ts` files. Routes, components, and any client-only file that tries to import `@/db` will fail the build immediately.

Importing **types** from `schema.ts` (e.g. `typeof postsTable.$inferSelect`) is safe everywhere — types are stripped at compile time. Importing the table **values** (`postsTable` itself) is server-only, so `schema.ts` typically does **not** get the server-only marker — that would block type imports too.

See the `bootstrap` skill for the full Drizzle setup.

## src/lib/

Non-UI code (data fetching, business logic, utilities) lives in `src/lib/`. Flat layout — no folders per domain. Files are grouped by suffix:

| Suffix | Purpose | Importable from |
| --- | --- | --- |
| `.functions.ts` | `createServerFn` exports. **Business logic lives in handler bodies — this is the service layer.** No thin wrappers. The compiler rewrites handlers into RPC stubs for client bundles, so this file is safe to import from anywhere. | Anywhere (client and server) |
| `.server.ts` | **Optional.** Server-only helpers, constants, background jobs, or cross-domain primitives consumed by `.functions.ts` files. TanStack Start treats `.server.ts` as server-only and rejects client imports. | Other `.functions.ts` and `.server.ts` files (including across domains). **Never from routes or components.** |
| `.schema.ts` | Zod schemas **and their inferred types** (`z.infer<...>`). Singular by convention. | Anywhere |
| `.test.ts` | Unit tests, matched to source: `apps.functions.test.ts`, `apps.server.test.ts`. | Test runner only |
| `.ts` (no suffix) | Isomorphic helpers — client-safe, framework-agnostic (`utils.ts`, `date.ts`, `format.ts`). | Anywhere |

### Core rules

1. **`.functions.ts` is the service layer.** Each `createServerFn` handler contains its business logic directly — DB calls, orchestration, shell-outs. No separate service file. No thin wrappers.

2. **`.server.ts` is optional.** Create it only when a domain has helpers, constants, or background jobs (e.g. `notifySubscribers`, `renderMarkdown`) worth naming. If everything fits inline in `.functions.ts`, skip the file. Don't create empty files for symmetry.

3. **`.server.ts` exports are cross-domain.** `posts.functions.ts` may import `findAuthorBySlug` from `authors.server.ts`. Avoids wrapping internal helpers in unnecessary `createServerFn` calls.

4. **Types live where they're produced.** Zod-inferred types stay next to their schemas in `.schema.ts`. Function return-shape interfaces live in the `.functions.ts` that returns them. Domain unions live in the file that owns the concept. **No dedicated `.types.ts` file**.

5. **Routes compose in loaders by default.** Each `createServerFn` in `src/lib/` takes one input and returns one well-defined shape; route loaders call several in parallel via `Promise.all` to assemble view data. **Escape hatch:** when a view requires 3+ pieces sharing an expensive context resolution, write one view-shaped `createServerFn` **in the route file itself** and call it from that route's loader. Keeping it in the route file (not `src/lib/`) signals it's route-coupled and not for reuse. Use sparingly.

6. **Naming.** Server functions are named after what they return or do, not after the route that calls them. `getPost`, `listPosts`, `publishPost` — not `getPostForDetailRoute`.

**CRITICAL: Never import `.server.ts` files from `src/routes/` or `src/components/`.** TanStack Start rejects the import at build time, but the error trace can be hard to read. Enforce it with a `no-restricted-imports` lint rule so failures surface immediately, not at build.

**CRITICAL: In `.functions.ts`, only use server-only resources inside handler bodies.** The compiler strips `createServerFn` handler bodies and replaces them with RPC stubs on the client — but other module-level code in the same file ships to the client. Reading `process.env`, importing `db`, calling `fs` / shell, etc. at module scope in a `.functions.ts` leaks server code (and secrets) into the client bundle. Keep that work inside handler bodies, or move it to `.server.ts` and call it from a handler.

For files that must be server-only but don't use the `.server.ts` naming convention, add this marker at the top:

```ts
import '@tanstack/react-start/server-only'
```

### Example layout

```
src/lib/
├── posts.functions.ts       # createServerFn exports — getPost, listPosts, publishPost, ...
├── posts.server.ts          # notifySubscribers, renderMarkdown, findPostBySlug
├── posts.schema.ts          # Zod schemas + their inferred types
├── posts.functions.test.ts
│
├── authors.functions.ts
├── authors.server.ts        # findAuthorBySlug — used by posts.functions.ts too
├── authors.schema.ts
│
├── comments.functions.ts    # listCommentsForPost, createComment
├── comments.schema.ts       # no .server.ts — nothing to put there
│
├── markdown.server.ts       # infra primitives, no domain
├── email.server.ts          # infra; notification sending
├── logger.ts
├── constants.server.ts
│
├── format.ts                # isomorphic display formatters
├── date.ts                  # isomorphic
└── utils.ts                 # isomorphic (cn)
```

## src/global.css

Contains shadcn/ui CSS variable definitions (the theme) and any global styles. Don't add component-specific styles here — those belong in Tailwind classes on the component.
