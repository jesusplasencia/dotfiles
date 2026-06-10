#!/bin/sh
# new-project — bootstrap a WorkShop project (Obsidian + Claude Code).
#
# Creates /mnt/WorkShop/<name> with a standard skeleton (CLAUDE.md, docs/,
# .gitignore, docs/.gitignore), runs `git init`, and creates the GitHub repo.
#
# Usage:  new-project <name> [--public]
#   <name>     project + repo name (also the folder under /mnt/WorkShop)
#   --public   create the GitHub repo public (default: private)
#
# Convention: docs/ is opened as the Obsidian vault; the repo root is the
# Claude Code cwd, so Claude sees notes + code in one git history.

set -eu

# Workspace root — override with WORKSHOP env var if your projects live elsewhere.
WORKSHOP="${WORKSHOP:-/mnt/WorkShop}"

# --- parse args ---------------------------------------------------------------
NAME=""
VISIBILITY="--private"
for arg in "$@"; do
    case "$arg" in
        --public)  VISIBILITY="--public" ;;
        --private) VISIBILITY="--private" ;;
        -*)        echo "[ERR] unknown flag: $arg" >&2; exit 1 ;;
        *)
            if [ -z "$NAME" ]; then
                NAME="$arg"
            else
                echo "[ERR] unexpected argument: $arg" >&2; exit 1
            fi
            ;;
    esac
done

if [ -z "$NAME" ]; then
    echo "Usage: new-project <name> [--public]" >&2
    exit 1
fi

TARGET="$WORKSHOP/$NAME"

# --- preflight ----------------------------------------------------------------
if [ -e "$TARGET" ]; then
    echo "[SKIP] $TARGET already exists. Nothing done."
    exit 0
fi

if ! command -v git >/dev/null 2>&1; then
    echo "[ERR] git not found in PATH." >&2; exit 1
fi
if ! command -v gh >/dev/null 2>&1; then
    echo "[ERR] gh (GitHub CLI) not found in PATH." >&2; exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
    echo "[ERR] gh is not authenticated. Run: gh auth login" >&2; exit 1
fi

echo "[..] Bootstrapping '$NAME' at $TARGET ($VISIBILITY)"

# --- scaffold -----------------------------------------------------------------
mkdir -p "$TARGET/docs"

cat > "$TARGET/CLAUDE.md" <<EOF
# $NAME

> Instructions for Claude Code. Auto-loaded when Claude runs in this repo root.

## What this is
_TODO: one-line description of the project._

## Layout
- \`docs/\` — Obsidian vault (notes, specs, ADRs, daily logs). Open **this folder**
  as a vault in Obsidian.
- _Code lives at the repo root (e.g. \`backend/\`, \`frontend/\`, \`helpers/\`)._

## Conventions
- Descriptive filenames in \`docs/\` (e.g. \`spec-2026-06-10.md\`, not \`untitled.md\`).
- Use YAML frontmatter (tags, date, description) on notes.
EOF

cat > "$TARGET/.gitignore" <<'EOF'
# Dependencies / build output
node_modules/
dist/
build/
.next/
.vercel/

# Logs & runtime
*.log
*.pid

# Local env / secrets
.env
.env.*

# OS
.DS_Store
EOF

cat > "$TARGET/docs/.gitignore" <<'EOF'
# Obsidian volatile state — keep this junk out of GitHub
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/cache
.obsidian/*.json.bak
.trash/
EOF

cat > "$TARGET/docs/README.md" <<EOF
---
title: $NAME
created: $(date +%Y-%m-%d)
tags: [project]
---

# $NAME — notes

Root note of the Obsidian vault for **$NAME**.
EOF

# --- git + GitHub -------------------------------------------------------------
git -C "$TARGET" init -b main >/dev/null
git -C "$TARGET" add -A
git -C "$TARGET" commit -q -m "chore: bootstrap $NAME"

gh repo create "$NAME" "$VISIBILITY" --source="$TARGET" --remote=origin --push

echo ""
echo "[OK] $NAME ready."
echo "     Repo:   $(gh repo view "$NAME" --json url -q .url 2>/dev/null || echo "(created)")"
echo "     Local:  $TARGET"
echo "     Next:   open '$TARGET/docs' as a vault in Obsidian; run Claude Code from $TARGET"
