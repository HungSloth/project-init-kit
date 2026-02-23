#!/usr/bin/env bash
set -euo pipefail

# ============================================================
#  project-init-kit — one script, fresh repo, let's go
# ============================================================

BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

banner() {
  echo ""
  echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════╗${NC}"
  echo -e "${CYAN}${BOLD}  ║   🚀  Project Init Kit  v1.0    ║${NC}"
  echo -e "${CYAN}${BOLD}  ╚══════════════════════════════════╝${NC}"
  echo ""
}

die() { echo -e "${RED}✗ $1${NC}" >&2; exit 1; }
info() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }

# --- preflight ---
command -v git >/dev/null  || die "git is not installed"
command -v gh  >/dev/null  || die "gh CLI is not installed (brew install gh / apt install gh)"
gh auth status &>/dev/null || die "gh is not authenticated — run 'gh auth login' first"

TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"
GH_USER="$(gh api user -q .login 2>/dev/null)" || die "Could not determine GitHub username"

banner

# --- prompts ---
read -rp "$(echo -e "${BOLD}Project name${NC} (kebab-case): ")" PROJECT_NAME
[[ -z "$PROJECT_NAME" ]] && die "Project name is required"
# sanitize to kebab-case
PROJECT_NAME="$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')"
info "Normalized name: ${BOLD}${PROJECT_NAME}${NC}"

read -rp "$(echo -e "${BOLD}Description${NC} (one-liner): ")" PROJECT_DESC
PROJECT_DESC="${PROJECT_DESC:-A new project}"

echo ""
echo -e "${BOLD}Visibility:${NC}"
echo "  1) public"
echo "  2) private"
read -rp "Choose [1/2, default=2]: " VIS_CHOICE
case "${VIS_CHOICE:-2}" in
  1) VISIBILITY="public" ;;
  *) VISIBILITY="private" ;;
esac
info "Visibility: ${VISIBILITY}"

read -rp "$(echo -e "${BOLD}License${NC} [MIT/none, default=MIT]: ")" LICENSE_CHOICE
LICENSE="${LICENSE_CHOICE:-MIT}"

# --- destination ---
PARENT_DIR="$(dirname "$TEMPLATE_DIR")"
DEST="${PARENT_DIR}/${PROJECT_NAME}"
[[ -d "$DEST" ]] && die "Directory already exists: ${DEST}"

echo ""
echo -e "${DIM}────────────────────────────────────${NC}"
echo -e "  Name:        ${BOLD}${PROJECT_NAME}${NC}"
echo -e "  Description: ${PROJECT_DESC}"
echo -e "  Visibility:  ${VISIBILITY}"
echo -e "  License:     ${LICENSE}"
echo -e "  Repo:        ${GH_USER}/${PROJECT_NAME}"
echo -e "  Local path:  ${DEST}"
echo -e "${DIM}────────────────────────────────────${NC}"
echo ""
read -rp "$(echo -e "${BOLD}Look good? [Y/n]:${NC} ")" CONFIRM
[[ "${CONFIRM:-y}" =~ ^[Nn] ]] && die "Aborted"

# --- scaffold ---
echo ""
info "Creating project directory..."
mkdir -p "$DEST"

# copy template files (skip init.sh itself and .git)
rsync -a \
  --exclude='.git' \
  --exclude='init.sh' \
  --exclude='README.md' \
  "$TEMPLATE_DIR/" "$DEST/"

# --- generate README ---
cat > "$DEST/README.md" <<EOF
# ${PROJECT_NAME}

${PROJECT_DESC}

## Getting Started

### With Dev Container (recommended)

1. Open in VS Code / Cursor
2. **Reopen in Container** when prompted
3. Start building

### Without Dev Container

\`\`\`bash
# your setup steps here
\`\`\`

## Structure

\`\`\`
.
├── .devcontainer/    # dev container config
├── src/              # source code
├── docs/             # documentation
├── scripts/          # utility scripts
├── CLAUDE.md         # AI assistant context
└── README.md
\`\`\`

## License

${LICENSE}
EOF

# --- license file ---
if [[ "$LICENSE" == "MIT" ]]; then
  YEAR="$(date +%Y)"
  cat > "$DEST/LICENSE" <<EOF
MIT License

Copyright (c) ${YEAR} ${GH_USER}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
fi

# --- personalize CLAUDE.md ---
sed -i "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" "$DEST/CLAUDE.md" 2>/dev/null || true
sed -i "s/{{PROJECT_DESC}}/${PROJECT_DESC}/g" "$DEST/CLAUDE.md" 2>/dev/null || true

# --- create starter dirs ---
mkdir -p "$DEST/src" "$DEST/docs" "$DEST/scripts"

# --- git init + push ---
info "Initializing git repo..."
cd "$DEST"
git init -b main --quiet
git add -A
git commit -m "🎉 Initial commit — scaffolded with project-init-kit" --quiet

info "Creating GitHub repo: ${GH_USER}/${PROJECT_NAME}..."
gh repo create "$PROJECT_NAME" \
  --"${VISIBILITY}" \
  --description "$PROJECT_DESC" \
  --source . \
  --remote origin \
  --push

echo ""
echo -e "${GREEN}${BOLD}  ✨ Done!${NC}"
echo ""
echo -e "  ${BOLD}Local:${NC}  cd ${DEST}"
echo -e "  ${BOLD}Remote:${NC} https://github.com/${GH_USER}/${PROJECT_NAME}"
echo ""
echo -e "  ${DIM}Open in your editor and start building.${NC}"
echo ""
