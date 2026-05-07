# React Testing Library Setup

Reference: https://bun.com/docs/guides/test/testing-library.md

## Installation

```bash
bun add -d @happy-dom/global-registrator
bun add -d @testing-library/react @testing-library/dom @testing-library/jest-dom @testing-library/user-event
```

## Preload files

Create `happydom.ts` at the project root:

```ts
import { GlobalRegistrator } from "@happy-dom/global-registrator";

GlobalRegistrator.register();
```

Create `testing-library.ts` at the project root:

```ts
import { afterEach, expect } from "bun:test";
import { cleanup } from "@testing-library/react";
import * as matchers from "@testing-library/jest-dom/matchers";

expect.extend(matchers);

afterEach(() => {
  cleanup();
});
```

Register both in `bunfig.toml`:

```toml
[test]
preload = ["./happydom.ts", "./testing-library.ts"]
```

## TypeScript types

Create `matchers.d.ts` at the project root so jest-dom matchers are recognised in `bun:test`:

```ts
import type { TestingLibraryMatchers } from "@testing-library/jest-dom/matchers";
import type { Matchers, AsymmetricMatchers } from "bun:test";

declare module "bun:test" {
  interface Matchers<T> extends TestingLibraryMatchers<typeof expect.stringContaining, T> {}
  interface AsymmetricMatchers extends TestingLibraryMatchers {}
}
```
