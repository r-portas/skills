---
name: maintain-changelog
description: >
  Maintains a CHANGELOG.md as you work on a project, using a date-based
  keepachangelog format. Use this skill whenever the user asks you to keep,
  maintain, or update a changelog, or says things like "update the changelog
  as you go", "keep a changelog of changes", or "log what you change". Also
  invoke this skill when the user starts a session and mentions wanting a
  record of what was done. The skill tells you what format to use, when to
  write entries, and how to write entries that are useful to a human reader.
---

# Maintaining a CHANGELOG.md

When asked to maintain a changelog, keep CHANGELOG.md up to date as you work. Update it after completing each meaningful unit of work — not after every file edit, but after each logical change you'd want someone to be able to understand at a glance later.

## Format

Use a date-based variant of the [keepachangelog](https://keepachangelog.com) format. Dates replace version numbers.

```markdown
# Changelog

## 2026-04-25

### Added
- Description of new functionality

### Changed
- Description of what was updated or improved

### Fixed
- Description of a bug that was resolved

### Removed
- Description of something that was deleted
```

**Available section types** (only include sections that apply):

| Section | When to use |
|---|---|
| `Added` | New features, files, endpoints, components, config options |
| `Changed` | Modifications to existing behavior, refactors, renames, updates |
| `Fixed` | Bug fixes, error handling, incorrect behavior corrected |
| `Removed` | Deleted files, deprecated features removed, functionality dropped |
| `Security` | Vulnerability patches, auth changes, permission fixes |
| `Deprecated` | Things that still work but are marked for future removal |

## Getting the date

Always use today's date (from the system or context). If you have access to a date command, run `date +%Y-%m-%d` to get it. Otherwise use the date from your system context.

## When there are already entries for today

If a `## YYYY-MM-DD` heading already exists for today, add your new entries under the appropriate section headings within that date block. Don't create a duplicate date heading.

## When the file doesn't exist

Create it from scratch:

```markdown
# Changelog

All notable changes to this project will be documented here.

## 2026-04-25

### Added
- ...
```

## Writing good entries

**Be specific enough to be useful, brief enough to skim.** A good entry tells someone what changed and why it matters — without reading the code.

Good entries:
- `Added dark mode toggle to user preferences page`
- `Fixed crash when uploading files larger than 10MB`
- `Removed legacy API v1 endpoints (superseded by v2)`
- `Changed email validation to allow plus signs in local part`

Poor entries (too vague):
- `Updated code`
- `Fixed bug`
- `Refactored`

Poor entries (too granular):
- `Updated line 42 of auth.ts`
- `Ran prettier`
- `Fixed typo in comment`

If a change only affects the developer experience (formatting, linting, internal renaming, updating a README or .gitignore) and wouldn't matter to someone using the project, skip it. The changelog is for meaningful changes to what the project does, not for housekeeping.

## Ordering

Put the most recent date at the top of the file. Within a date block, you can list entries in the order you completed them.

## Example — a session where you added a feature and fixed a bug

```markdown
# Changelog

All notable changes to this project will be documented here.

## 2026-04-25

### Added
- User profile page with avatar upload and bio editing

### Fixed
- Profile images now display correctly on Safari (was showing broken image on load)
```
