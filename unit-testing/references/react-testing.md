# React Component Testing

Conventions for testing React components with React Testing Library and HappyDOM. Use the `bootstrap` skill to install and configure both.

## TypeScript DOM types

Add `"dom"` to the `lib` array in `tsconfig.json` to get TypeScript DOM types across all test files:

```json
{ "compilerOptions": { "lib": ["ESNext", "DOM"] } }
```

## Writing component tests

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

## Query priority

Prefer queries that reflect how users interact with the UI:

1. `getByRole` — most resilient, matches accessible semantics
2. `getByLabelText` — for form fields
3. `getByPlaceholderText` — fallback for unlabelled inputs
4. `getByTestId` — last resort; couples tests to implementation
