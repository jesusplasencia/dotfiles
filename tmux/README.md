# tmux

Personal tmux configuration. Prefix key: `Ctrl+b` (default).

---

## Sessions

### Create a new session

```bash
tmux new -s <name>
```

### Create a session from within tmux (no nesting)

Do not run `tmux new` inside an active session — it creates a nested tmux instance.
Instead, use the command prompt to create a detached session and then switch to it:

```
Ctrl+b :new-session -d -s <name>
Ctrl+b s                          # open session picker and select it
```

Or just detach first and create from the shell:

```
Ctrl+b d                          # detach from current session
tmux new -s <name>
```

### Rename the current session

```
Ctrl+b $
```

Type the new name and press `Enter`.

### List / switch sessions

```
Ctrl+b s
```

Fuzzy-searchable picker. Navigate with arrows, select with `Enter`.

---

## Windows (tabs)

| Action              | Binding       |
|---------------------|---------------|
| New window          | `Ctrl+b c`    |
| Next window         | `Ctrl+b n`    |
| Previous window     | `Ctrl+b p`    |
| Go to window N      | `Ctrl+b <N>`  |
| Rename window       | `Ctrl+b ,`    |
| Close window        | `exit` or `Ctrl+b &` |

---

## Panes (splits)

| Action                    | Binding        |
|---------------------------|----------------|
| Vertical split (side by side) | `Ctrl+b \|` |
| Horizontal split (top/bottom) | `Ctrl+b -`  |
| Close pane                | `exit`         |
| Zoom pane (toggle fullscreen) | `Ctrl+b z` |

---

## Navigating between panes

Use the same keys whether you are in a shell pane or inside nvim:

| Direction | Binding    |
|-----------|------------|
| Left      | `Ctrl+h`   |
| Down      | `Ctrl+j`   |
| Up        | `Ctrl+k`   |
| Right     | `Ctrl+l`   |

> Powered by `vim-tmux-navigator` — these bindings work seamlessly across tmux panes and nvim splits without pressing the prefix.

---

## Detach / reattach

```bash
Ctrl+b d          # detach (session keeps running in background)
tmux attach       # reattach to last session
tmux attach -t <name>   # reattach to a specific session
```

Sessions persist across terminal closes and are auto-saved every 15 minutes (`tmux-continuum`).  
Manual save: `Ctrl+b Ctrl+s` — Manual restore: `Ctrl+b Ctrl+r`
