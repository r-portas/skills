---
name: unit-testing
description: >
  Roy's conventions for writing tests — Bun test runner, mocking with
  Bun's built-in mock API, and React component testing with React Testing
  Library and HappyDOM. Consult whenever writing, editing, or reviewing
  any test file (*.test.ts, *.test.tsx), or when asked about mocking,
  test structure, or testing setup.
user-invocable: false
metadata:
  author: r-portas
---

# Unit Testing

## Test runner

Use Bun's built-in test runner — no install needed.

```bash
bun test                  # run all tests
bun test --watch          # re-run on file changes
bun test src/lib/foo.test.ts  # run a specific file
```

## File naming and location

Place test files next to the source file they test:

```
src/
├── lib/
│   ├── format-date.ts
│   └── format-date.test.ts
└── components/
    ├── search-input.tsx
    └── search-input.test.tsx
```

Use `*.test.ts` for logic and `*.test.tsx` for React components.

## Test structure

Import everything from `bun:test`:

```ts
import { describe, it, expect, beforeEach, afterEach } from "bun:test";

describe("formatDate", () => {
  it("formats a date with the default locale", () => {
    expect(formatDate(new Date("2024-01-15"))).toBe("Jan 15, 2024");
  });

  it("returns an empty string for null", () => {
    expect(formatDate(null)).toBe("");
  });
});
```

- Use `describe` to group related cases; nest only when there's a real hierarchy
- Prefer `it` over `test` — reads more naturally: _"it formats a date"_
- One logical assertion per `it` keeps failures easy to diagnose

## Mocking

### Inline function mock

```ts
import { mock } from "bun:test";

const sendEmail = mock(() => Promise.resolve({ ok: true }));
```

### Replace a whole module

```ts
import { mock } from "bun:test";

mock.module("./api-client", () => ({
  fetchUser: mock(() => Promise.resolve({ id: 1, name: "Test User" })),
}));
```

`mock.module()` overrides persist across the test file. Prefer `beforeEach` + `mock.restore()` for isolated per-test overrides (see below).

### Spy on an existing method

```ts
import { spyOn, expect } from "bun:test";

const spy = spyOn(analytics, "track");
doSomething();
expect(spy).toHaveBeenCalledTimes(1);
```

### Restore mocks

```ts
import { afterEach, mock } from "bun:test";

afterEach(() => {
  mock.restore(); // restores spied-on functions; does NOT reset mock.module() overrides
});
```

### What to mock

Mock at system boundaries — anything that reaches outside the process or produces non-deterministic output:

- Outbound HTTP calls (`fetch`, API clients)
- File I/O beyond the test's own fixtures
- `Date.now()`, `Math.random()`
- External services (email, analytics, payments)

**Do not mock internal modules.** If two modules in the same codebase need to be tested in isolation, that's a design signal — prefer extracting a pure function or refactoring the dependency instead.

## React component testing

### Install

```bash
bun add -d @testing-library/react @testing-library/user-event @testing-library/jest-dom @happy-dom/global-registrator
```

### HappyDOM setup

Create `test-setup.ts` at the project root:

```ts
import { GlobalRegistrator } from "@happy-dom/global-registrator";
import "@testing-library/jest-dom";

GlobalRegistrator.register();
```

Register it as a preload in `bunfig.toml`:

```toml
[test]
preload = ["./test-setup.ts"]
```

### Writing component tests

Add `/// <reference lib="dom" />` at the top of each `.test.tsx` file to get TypeScript DOM types:

```tsx
/// <reference lib="dom" />

import { describe, it, expect } from "bun:test";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

describe("SearchInput", () => {
  it("calls onSearch when the user submits", async () => {
    const onSearch = mock(() => {});
    render(<SearchInput onSearch={onSearch} />);

    await userEvent.type(screen.getByRole("searchbox"), "hello{Enter}");

    expect(onSearch).toHaveBeenCalledWith("hello");
  });
});
```

### Query priority

Prefer queries that reflect how users interact with the UI:

1. `getByRole` — most resilient, matches accessible semantics
2. `getByLabelText` — for form fields
3. `getByPlaceholderText` — fallback for unlabelled inputs
4. `getByTestId` — last resort; couples tests to implementation

## Before finishing

After writing or editing any test file, verify:

- [ ] `bun test` passes with no errors
- [ ] No `.only` calls left in the file
- [ ] Mocks are restored in `afterEach` where relevant
- [ ] No `getByTestId` used when a role or label query would work
