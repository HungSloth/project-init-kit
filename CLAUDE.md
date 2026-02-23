# CLAUDE.md — Project Context

## Project: {{PROJECT_NAME}}

{{PROJECT_DESC}}

## Structure

- `src/` — source code
- `docs/` — documentation and notes
- `scripts/` — utility/build scripts
- `.devcontainer/` — dev container configuration

## Conventions

- **Language:** Determine from files in `src/`. If empty, ask before assuming.
- **Style:** Follow existing patterns. When starting fresh, prefer simple and readable over clever.
- **Commits:** Use conventional commits (`feat:`, `fix:`, `docs:`, `chore:`).
- **Branching:** `main` is the default branch. Create feature branches for non-trivial changes.

## Dev Environment

This project uses a dev container (`.devcontainer/devcontainer.json`) with:
- Node.js (LTS), Python, Git, GitHub CLI, Docker-in-Docker
- Pre-configured VS Code extensions for formatting and linting

To add project-specific dependencies, update `postCreateCommand` in `devcontainer.json`
or add a `scripts/setup.sh`.

## Working With This Project

1. **Read this file first** to understand the project layout.
2. **Check `docs/`** for any design decisions, ADRs, or notes.
3. **Check `scripts/`** for any existing automation before writing new scripts.
4. **Keep this file updated** as the project evolves — it's the source of truth for AI assistants.

## Notes

_Add project-specific notes, decisions, and context below as the project develops._
