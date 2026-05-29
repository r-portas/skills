# React Testing Library Setup

Reference: https://bun.com/docs/guides/test/testing-library.md

## Installation

```bash
bun add -d @happy-dom/global-registrator
bun add -d @testing-library/react @testing-library/dom @testing-library/jest-dom @testing-library/user-event
```

## Preload files

Create `src/happydom.ts`:

```ts
import { GlobalRegistrator } from "@happy-dom/global-registrator";

GlobalRegistrator.register();
```

Create `src/testing-library.ts`:

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
preload = ["./src/happydom.ts", "./src/testing-library.ts"]
```

## TypeScript types

Create `src/matchers.d.ts` so jest-dom matchers are recognised in `bun:test`:

```ts
import type { TestingLibraryMatchers } from "@testing-library/jest-dom/matchers";
import type { Matchers, AsymmetricMatchers } from "bun:test";

declare module "bun:test" {
  interface Matchers<T> extends TestingLibraryMatchers<typeof expect.stringContaining, T> {}
  interface AsymmetricMatchers extends TestingLibraryMatchers {}
}
```
