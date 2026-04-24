# AGENTS.md

Guidelines for AI agents working in this repository.

## Repository Overview

This repository contains **Agent Skills** for AI agents following the [Agent Skills specification](https://agentskills.io/specification.md).

## Repository Structure

```
skills/
├── skill-name/            # Agent Skills
│   └── SKILL.md           # Required skill file
└── README.md
```

## Agent Skills Specification

Skills follow the [Agent Skills spec](https://agentskills.io/specification.md).

## Git Workflow

### Branch Naming

- New skills: `feature/skill-name`
- Improvements: `fix/skill-name-description`
- Documentation: `docs/description`

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat: add skill-name skill`
- `fix: improve clarity in page-cro`
- `docs: update README`

### Keeping Skills in Sync

The `preferred-npm-packages` and `bootstrap` skills are closely related:

- When a new package is added to `preferred-npm-packages` that has an opinionated setup, add a corresponding reference file in `bootstrap/references/` and update the packages table in `bootstrap/SKILL.md`.
- When a bootstrap reference is added or removed, update the corresponding entry in `preferred-npm-packages` to reflect whether to use the bootstrap skill for setup.

### After Adding a Skill

After creating or adding a skill, add a row to the skills table in `README.md`:

```markdown
| [skill-name](./skill-name/SKILL.md) | Short description |
```

### Pull Request Checklist

- [ ] `name` matches directory name exactly
- [ ] `name` follows naming rules (lowercase, hyphens, no `--`)
- [ ] `description` is 1-1024 chars with trigger phrases
- [ ] `SKILL.md` is under 500 lines
- [ ] No sensitive data or credentials