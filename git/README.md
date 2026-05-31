# git

Global Git configuration with machine-local identity injection.

## Stow

```bash
cd ~/dotfiles
stow --target="$HOME" git/
```

Creates symlinks:
- `~/.gitconfig` → `git/.gitconfig`
- `~/.gitignore_global` → `git/.gitignore_global`

## Identity setup

Identity (name + email) lives in `~/.gitconfig.local`, which is gitignored and never committed. Run once per machine:

```bash
bash ~/dotfiles/scripts/setup-git.sh
```

## GitHub authentication

```bash
gh auth login
```

Once authenticated, `gh auth git-credential` handles HTTPS tokens automatically — no manual token management needed.

## Aliases

| Alias | Expands to | Description |
|-------|-----------|-------------|
| `s`   | `status -sb` | Short status |
| `a`   | `add` | Stage files |
| `ap`  | `add -p` | Stage interactively (hunk by hunk) |
| `c`   | `commit` | Commit (opens editor) |
| `cm`  | `commit -m` | Commit with inline message |
| `ca`  | `commit --amend --no-edit` | Amend last commit without editing message |
| `p`   | `push origin HEAD` | Push current branch |
| `pf`  | `push origin HEAD --force-with-lease` | Safe force-push |
| `l`   | `log --oneline --graph --decorate -20` | Last 20 commits as graph |
| `la`  | `log --oneline --graph --decorate --all` | Full branch graph |
| `d`   | `diff` | Unstaged diff |
| `ds`  | `diff --staged` | Staged diff |
| `co`  | `checkout` | Checkout |
| `sw`  | `switch` | Switch branches |
| `br`  | `branch -vv` | List branches with tracking info |
| `undo`| `reset HEAD~1 --mixed` | Undo last commit, keep changes unstaged |
