# 🚀 project-init-kit

Clone this repo. Run one script. Get a fresh project with its own GitHub repo, dev container, and scaffolding — zero fiddling.

## Usage

```bash
# clone the template (only need to do this once)
git clone https://github.com/YOUR_USER/project-init-kit.git ~/project-init-kit

# start a new project
~/project-init-kit/init.sh
```

The script will:
1. Prompt for project name, description, visibility, and license
2. Copy the template files into a sibling directory
3. Initialize a git repo with an initial commit
4. Create a GitHub repo and push

## What's Included

| File | Purpose |
|------|---------|
| `init.sh` | Interactive project scaffolder |
| `.devcontainer/` | Universal dev container (Node, Python, Docker, GH CLI) |
| `CLAUDE.md` | AI assistant context (auto-populated with project name) |
| `.gitignore` | Sane defaults for most project types |
| `.env.example` | Template for environment variables |

## Requirements

- `git`
- [`gh` CLI](https://cli.github.com/) (authenticated)
- `rsync`

## Customizing

This is **your** template. Fork it, tweak it, make it yours:

- Add your preferred linter configs (`.eslintrc`, `pyproject.toml`, etc.)
- Add a `Makefile` or `justfile` if that's your thing
- Swap the devcontainer image for something project-specific
- Add more prompts to `init.sh` (language choice, framework, etc.)

## License

MIT
