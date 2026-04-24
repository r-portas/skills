---
name: preferred-npm-packages
description: >
  Roy's preferred NPM package choices and technology stack. Consult this
  skill whenever choosing dependencies, scaffolding a new project, suggesting
  libraries, or making any technology decisions — even if the user hasn't
  explicitly asked which package to use. Always prefer these packages over
  alternatives unless there's a compelling technical reason not to, and flag
  when you're deviating from them.
user-invocable: false
allowed-tools: WebFetch(https://es-toolkit.dev/*), WebFetch(https://orm.drizzle.team/*), WebFetch(https://zod.dev/*), WebFetch(https://tanstack.com/*)
metadata:
  author: r-portas
---

# Preferred NPM Packages

When working on Roy's projects, default to the packages below. If a task
requires a library not listed here, pick the simplest option and mention the
choice — don't silently pull in something heavyweight.

## Language
- **TypeScript** — always. No plain JS files in new projects.

## Runtime & Package Manager
- **Bun** — use `bun` commands for running, installing, and testing.
  Not `node`, `npm`, `yarn`, or `pnpm`.

## Meta-framework
- **TanStack Start** — full-stack React framework. Use this for new web apps.
  Docs: https://tanstack.com/llms.txt

## HTTP
- **Native `fetch`** — Bun and modern runtimes support it natively.
  Avoid axios, ky, got, or any HTTP client library. No install needed.

## Validation
- **zod** — schema definition, validation, and TypeScript type inference.
  Use it at API boundaries, form inputs, and environment variables.
  Docs: https://zod.dev/llms.txt
  ```
  bun add zod
  ```

## Dates
- **date-fns** — functional, tree-shakeable date utilities.
  Avoid moment.js, dayjs, luxon.
  Use the **bootstrap** skill to set up date-fns.

## Formatting & Linting
- **oxfmt + oxlint** — formatting and linting. Avoid Prettier and ESLint.
  Use the **bootstrap** skill to set up oxfmt and oxlint.

## Styling
- **Tailwind CSS + shadcn/ui** — utility-first styling with shadcn for
  component primitives. Avoid styled-components, CSS modules, or other
  CSS-in-JS solutions.
  ```
  bun add tailwindcss @tailwindcss/vite
  bunx shadcn@latest init
  bunx shadcn@latest add <component>
  ```

## Database / ORM
- **Drizzle ORM + Bun SQLite** — for local and embedded databases.
  Use Drizzle's query builder; avoid Prisma, Knex, TypeORM.
  Docs: https://orm.drizzle.team/llms.txt
  Bun SQLite is built-in (`import { Database } from 'bun:sqlite'`), no install needed.
  Use the **bootstrap** skill to set up Drizzle.

## Utility Functions
- **es-toolkit** — modern lodash alternative with built-in TypeScript types,
  significantly smaller bundle size, and faster runtime. Import specific
  functions (`import { groupBy } from 'es-toolkit'`).
  Docs: https://es-toolkit.dev/llms.txt
  ```
  bun add es-toolkit
  ```

## Testing
- **Bun test runner** (`bun test`) — built-in, no install needed.
- **React Testing Library + HappyDOM** — add these when testing React
  components. Use HappyDOM as the DOM environment (not jsdom).
  ```
  bun add -d @testing-library/react @testing-library/user-event happydom
  ```
- Avoid Jest and Vitest in new projects (acceptable in legacy codebases
  that already use them).
