# My Way of Working with AI Agents

These are my personal conventions for working with AI coding agents. They apply regardless of which tool I'm using (Rovo Dev, Claude Code, Gemini CLI, etc.).

## 1. Planning — Use `~/.memory/ck_*/` Directories

- When starting a non-trivial task, create a `ck_*/` plan directory **inside `~/.memory/`** (e.g., `~/.memory/ck_my-feature/` or `~/.memory/ck_DSP-1234/`).
- **Never create `ck_*/` directories inside a repository** — they pollute the working tree and may not be git-ignored in all repos.
- `~/.memory/` is the single home for all local agent working memory — plans, session logs, and notes.
- Keep them after the task is complete — they serve as future reference.

**Structure:**
```
~/.memory/ck_feature/
├── progress.md               # Running log: decisions, progress, blockers, evidence. Keep updating.
├── 01-overview.md            # Problem statement, scope
├── 02-architecture.md        # Diagrams, data flows
├── 03-implementation-plan.md # Steps, key file changes
├── 04-testing.md             # Test scenarios
├── topics/                   # Deep dives as needed
└── reviews/                  # One file per review round (round-1.md, round-2.md, …)
```

`progress.md` is the living log — always append, never overwrite. Track decisions, what was done, blockers, test evidence, PR links, monitoring cycles.

## 2. Reviewable Steps

- Prefer small, reviewable changes. Show diffs (or a clear summary + file list) before committing.
- Do not make large sweeping changes without first proposing the plan.

## 3. Commits / Pushes

- Never commit, amend, push, or force-push unless I explicitly instruct you to.
- Always wait for explicit review/approval before committing.

## 4. Pre-commit Hooks

- Do not skip pre-commit hooks. Only skip if I explicitly request it, and document why.

## 5. Safety

- If you accidentally violate any of these rules, acknowledge it immediately, stop, and ask how I want to proceed.

## 6. Code Formatting

- Before editing or creating any file, look for the nearest formatter config (`.prettierrc`, `prettier.config.js`, etc.) — starting from the file's directory and walking up to the repo root.
- Apply those formatting rules manually. Do not assume defaults.
- Prefer the config closest to the file being edited.

## 7. Git Worktree Structure

Any repository set up with the `wt` CLI uses this **git worktree layout**:

```
<repo-root>/
├── master/          ← main worktree — always on the primary branch (e.g. `master` or `main`)
└── agents/
    ├── agent-001/   ← worktree for agent 1 — base branch: `agent/001`
    ├── agent-002/   ← worktree for agent 2 — base branch: `agent/002`
    ├── agent-003/   ← worktree for agent 3 — base branch: `agent/003`
    └── ...
```

### Rules when working inside `agents/agent-NNN/`

- The worktree's **base branch** is `agent/NNN` (e.g. `agent/001`, `agent/003`).
- **Treat `agent/NNN` as the equivalent of `master`** for this worktree.
- **Always create a feature branch off `agent/NNN`**, never work directly on `agent/NNN`.
- Before starting any work: check `git branch` — if you're on `agent/NNN`, create a feature branch first:
  ```bash
  git checkout -b <feature-branch-name>
  ```
- Feature branch naming: follow the repo convention (e.g. `issue/TICKET-123-short-description`).
- Never commit directly to `agent/NNN` — it is a base branch managed by `wt sync`.

### Rules when working inside `master/`

- The worktree is on the primary branch (e.g. `master` or `main`).
- Treat it the same as a normal repo root — create feature branches off `master` as usual.
- This worktree is used for: PR reviews, syncing, git operations across all worktrees.

### `wt` CLI reference

| Command | What it does |
|---|---|
| `wt sync` | Fetch + fast-forward `agent/NNN` + rebase feature branch |
| `wt clean` | Reset worktree to base branch (`agent/NNN`), delete feature branch |
| `wt close` | Close the tmux window for this worktree |
| `wt list` | Show all worktrees and their status |
