#!/bin/sh
# Run once per machine to create ~/.gitconfig.local with your identity.
# This file is gitignored and never committed.

LOCAL="$HOME/.gitconfig.local"

if [ -f "$LOCAL" ]; then
    echo "[SKIP] ~/.gitconfig.local already exists. Delete it and re-run to reset."
    exit 0
fi

echo ""
printf "Git name  : "; read -r git_name
printf "Git email : "; read -r git_email

if [ -z "$git_name" ] || [ -z "$git_email" ]; then
    echo "[ERROR] Name and email cannot be empty."
    exit 1
fi

cat > "$LOCAL" <<EOF
[user]
    name  = $git_name
    email = $git_email
EOF

echo "[OK] ~/.gitconfig.local created."
