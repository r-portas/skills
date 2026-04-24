# Agent Skills

A collection of agent skills for Claude Code.

## Installation

### Option 1: Via the `skills` NPM package

Install individual skills using the `skills` CLI:

```bash
bunx skills add r-portas/skills/<skill-name>
```

### Option 2: Clone and symlink

Clone the repo and run the install script to symlink all skills into Claude's skills directory:

```bash
git clone https://github.com/r-portas/skills.git ~/Projects/skills
cd ~/Projects/skills
./install.sh
```

Re-run `./install.sh` whenever you add new skills — existing symlinks are left untouched.

## Skills

| Skill | Description |
|-------|-------------|
| [preferred-npm-packages](./preferred-npm-packages/SKILL.md) | Preferred NPM packages and technology stack |
