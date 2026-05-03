# date-fns Setup

## Installation

```bash
bun add date-fns
```

## Helper module

Create `src/lib/date.ts`:

```ts
import { format, formatDistanceToNow } from "date-fns";

/**
 * Formats a date as a precise, human-readable string for tooltips and detailed display.
 *
 * @example
 * formatExact(new Date("2025-04-06T21:30:00"))
 * // "Apr 6, 2025, 9:30:00 PM"
 */
export function formatExact(date: Date): string {
  return format(date, "PPpp");
}

/**
 * Formats a date as a relative string from the current time.
 *
 * @example
 * formatRelative(new Date(Date.now() - 3 * 24 * 60 * 60 * 1000))
 * // "3 days ago"
 */
export function formatRelative(date: Date): string {
  return formatDistanceToNow(date, { addSuffix: true });
}
```

Import from `@/lib/date` wherever date formatting is needed — don't import `date-fns` directly in components.
