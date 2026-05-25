---
name: tanstack-start-project-structure
description: >
  Directory and file layout conventions for Roy's TanStack Start projects.
  Consult whenever creating files, adding routes, scaffolding new components
  or hooks, or deciding where to place any new file or folder.
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

TanStack Start uses file-based routing. Each file in `src/routes/` maps to a URL segment:

```
src/routes/
├── __root.tsx        # Root layout (nav, providers, etc.)
├── index.tsx         # / (home)
├── about.tsx         # /about
└── posts/
    ├── index.tsx     # /posts
    └── $id.tsx       # /posts/:id
```

**CRITICAL: Never `export` component functions from route files.** Exported functions are included in the main bundle and bypass code splitting entirely. Keep component functions unexported.

**CRITICAL: Loaders are isomorphic — they run on both server and client.** Never put DB queries, secrets, or Node-only code directly in a loader. Always wrap server-only logic in `createServerFn` and call it from the loader.

## src/db/

Two files live directly under `src/db/`:

- **`index.ts`** — the Drizzle client, imported wherever queries are run
- **`schema.ts`** — all table definitions

```
src/db/
├── index.ts    # export const db = drizzle(...)
└── schema.ts   # export const usersTable = sqliteTable(...)
```

See the `bootstrap` skill for the full Drizzle setup.

## src/lib/

Non-UI code (data fetching, business logic, utilities) lives in `src/lib/`. Within a domain, split files by bundle boundary:

| Suffix | Purpose |
| --- | --- |
| `.server.ts` | Server-only modules — DB queries, secrets, Node-only imports. Matched by the `**/*.server.*` pattern: any client-side import triggers a build-time error with a full import trace. |
| `.functions.ts` | `createServerFn` definitions — safe to import from client code because the compiler rewrites handlers into RPC stubs. Calls into `.server.ts` for the actual logic. |
| `.schemas.ts` | Shared Zod validation schemas — safe to import from both client and server. |
| `.ts` | Isomorphic utilities safe to import anywhere. |

Put business logic and DB access in `.server.ts`, then call it from a thin `.functions.ts` wrapper. This is the recommended split — it keeps the client-safe RPC surface separate from pure server-only code.

For files that don't use the `.server.ts` naming convention but must be server-only, add this marker at the top:

```ts
import '@tanstack/react-start/server-only'
```

```
src/lib/
├── repos.server.ts       # DB queries and business logic (server-only)
├── repos.functions.ts    # createServerFn wrappers that call repos.server.ts
├── repos.schemas.ts      # Shared Zod schemas used by both server and client
└── utils.ts              # Shared helpers (isomorphic)
```

## src/global.css

Contains shadcn/ui CSS variable definitions (the theme) and any global styles. Don't add component-specific styles here — those belong in Tailwind classes on the component.
