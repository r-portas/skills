# React Testing Library Setup

## Installation

```bash
bun add -d @testing-library/react @testing-library/user-event @testing-library/jest-dom @happy-dom/global-registrator
```

## HappyDOM preload

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
