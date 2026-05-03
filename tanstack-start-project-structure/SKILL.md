---
name: tanstack-start-project-structure
description: >
  Directory and file layout conventions for Roy's TanStack Start projects.
  Consult whenever deciding where to place a new file or folder.
user-invocable: false
metadata:
  author: r-portas
---

# Project Structure

## Directory layout

| Path | What goes there |
| --- | --- |
| `src/routes/` | TanStack Start file-based routes |
| `src/components/ui/` | Base UI primitives (shadcn/ui conventions) |
| `src/components/<domain>/` | Domain-specific component groupings (e.g. `home/`, `posts/`) |
| `src/components/` | Shared components used across multiple routes |
| `src/hooks/` | Custom React hooks |
| `src/lib/` | Non-UI utilities, data fetching, helpers |
| `src/db/` | Database client and schema (Drizzle) |
| `src/global.css` | shadcn theme variables and global CSS |

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

## src/global.css

Contains shadcn/ui CSS variable definitions (the theme) and any global styles. Don't add component-specific styles here — those belong in Tailwind classes on the component.
