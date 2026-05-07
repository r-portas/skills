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
import { describe, test, expect, beforeEach, afterEach } from "bun:test";

describe("formatDate", () => {
  test("formats a date with the default locale", () => {
    expect(formatDate(new Date("2024-01-15"))).toBe("Jan 15, 2024");
  });

  test("returns an empty string for null", () => {
    expect(formatDate(null)).toBe("");
  });
});
```

- Use `describe` to group related cases; nest only when there's a real hierarchy
- Use `test` over `it`
- One logical assertion per `test` keeps failures easy to diagnose

## Mocking

Mock at system boundaries — anything that reaches outside the process or produces non-deterministic output: outbound HTTP, file I/O, time, external services.

**Do not mock internal modules.** If internal modules need isolation, extract a pure function instead.

### Example: mocking a module dependency

Given a function that reads a file:

```ts
// get-post.ts
import { readFileSync } from "node:fs";

export function getPost(id: string): string {
  return readFileSync(`posts/${id}.md`, "utf-8");
}
```

Mock `node:fs` with `mock.module()` before importing the module under test. Define the mock function separately so you have a reference for assertions.

```ts
// get-post.test.ts
import { describe, test, expect, mock, beforeEach } from "bun:test";
import { getPost } from "./get-post";

const mockReadFileSync = mock(() => "# Hello World");

mock.module("node:fs", () => ({
  readFileSync: mockReadFileSync,
}));

describe("getPost", () => {
  beforeEach(() => {
    mockReadFileSync.mockClear();
  });

  test("reads the correct file path and returns content", () => {
    expect(getPost("my-post")).toBe("# Hello World");
    expect(mockReadFileSync).toHaveBeenCalledWith("posts/my-post.md", "utf-8");
  });
});
```

Key points:
- `mock.module()` overrides persist for the entire file and cannot be undone with `mock.restore()`
- Call `mockClear()` in `beforeEach` to reset call counts between tests
- For per-test return value variation, re-call `mockReadFileSync.mockImplementation(...)` in `beforeEach`

### Spying on an existing method

Use `spyOn` when you want to observe calls on an object you already have, without replacing the whole module:

```ts
import { test, expect, spyOn, afterEach, mock } from "bun:test";

const spy = spyOn(console, "error");

afterEach(() => {
  mock.restore(); // restores spied-on functions; does NOT reset mock.module() overrides
});

test("logs an error on invalid input", () => {
  processInput(null);
  expect(spy).toHaveBeenCalledTimes(1);
});
```

## React component testing

Use the `bootstrap` skill to install and configure React Testing Library and HappyDOM.

### Writing component tests

Add `"dom"` to the `lib` array in `tsconfig.json` to get TypeScript DOM types across all test files:

```json
{ "compilerOptions": { "lib": ["ESNext", "DOM"] } }
```

Use `@testing-library/user-event` for interactions. Call `userEvent.setup()` inside each test — per the docs, this creates an isolated instance with its own event state:

```tsx
import { describe, test, expect, mock } from "bun:test";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

describe("SearchInput", () => {
  test("calls onSearch when the user submits", async () => {
    const user = userEvent.setup();
    const onSearch = mock(() => {});
    render(<SearchInput onSearch={onSearch} />);

    await user.type(screen.getByRole("searchbox"), "hello{Enter}");

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
