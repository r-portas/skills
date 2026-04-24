# Drizzle Setup

Drizzle is currently in beta, so both packages need the `@beta` tag.

## Installation

```bash
bun add drizzle-orm@beta
bun add -d drizzle-kit@beta @types/bun
```

`drizzle-kit` is the CLI tool for schema pushes, migrations, and Drizzle Studio — dev dependency only.

## Scripts

Add to `package.json`. The `bun --bun` prefix is required so drizzle-kit resolves the SQLite driver through Bun's runtime rather than a Node.js shim:

```json
{
  "scripts": {
    "drizzle:push": "bun --bun drizzle-kit push",
    "drizzle:studio": "bun --bun drizzle-kit studio"
  }
}
```

## Config

Create `drizzle.config.ts` at the project root:

```ts
import { defineConfig } from "drizzle-kit";

export default defineConfig({
  out: "./drizzle",
  schema: "./src/db/schema.ts",
  dialect: "sqlite",
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
});
```

Set `DATABASE_URL` in `.env`:

```bash
DATABASE_URL=file:./local.db
```

## Client

Create `src/db/index.ts`. Use `drizzle-orm/bun-sqlite` — the Bun-native driver, not the generic sqlite adapter:

```ts
import { drizzle } from "drizzle-orm/bun-sqlite";
import * as schema from "./schema";

export const db = drizzle(process.env.DATABASE_URL!, { schema });
```

Passing `schema` enables relational queries via `db.query`. If you're only using the query builder, it's optional.

## Schema

Create `src/db/schema.ts`. Example table:

```ts
import { int, sqliteTable, text } from "drizzle-orm/sqlite-core";

export const notesTable = sqliteTable("notes", {
  id: int().primaryKey({ autoIncrement: true }),
  content: text().notNull(),
  createdAt: int({ mode: "timestamp_ms" }).notNull(),
  updatedAt: int({ mode: "timestamp_ms" }).notNull(),
});
```

`int({ mode: "timestamp_ms" })` stores timestamps as milliseconds since epoch and maps them to JS `Date` objects — assign `new Date()` or `Date.now()` directly.

## Push the schema

```bash
bun drizzle:push
```

For development this is the fast path: no migration files, just push and query. For production, use `drizzle-kit generate` to produce tracked SQL migration files, then `drizzle-kit migrate` to apply them.

Browse the database in Drizzle Studio:

```bash
bun drizzle:studio
```
