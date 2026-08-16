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

## 6. Code Comments

- **Do not add comments to code you write or edit** unless the logic is genuinely non-obvious and requires explanation.
- Never add comments that just describe what the code does (e.g. `// increment counter`, `// call the API`).
- Never add section divider comments or labels when editing existing files.
- If existing comments are already present, leave them as-is — do not add more.
- Prefer self-documenting code (clear variable/function names) over comments.

## 7. Code Formatting

- Before editing or creating any file, look for the nearest formatter config (`.prettierrc`, `prettier.config.js`, etc.) — starting from the file's directory and walking up to the repo root.
- Apply those formatting rules manually. Do not assume defaults.
- Prefer the config closest to the file being edited.

## 8. Git Worktrees

I use **ephemeral git worktrees** for parallel work — one per feature, created on
demand and deleted when the PR merges. There is **no** long-lived
`master/`+`agents/agent-NNN/` pool and **no** `agent/NNN` base branches anymore.

### The model

- Every registered repo is a plain git clone. Worktrees are ordinary `git worktree`
  worktrees (git-default layout), created per-feature and thrown away after merge.
  There is no single-vs-worktree distinction: "single-use" repos just use branches
  and never create worktrees, but any repo *can* via vanilla `git worktree`.
- Use standard `git worktree` commands to inspect and manage worktrees. It sees
  worktrees created by other tools (e.g. Claude Code's `.claude/worktrees/`).

### Rules when working inside a worktree

- You're on a normal feature branch — treat it like any branch.
- Rebase onto the latest primary branch with `git fetch origin master` followed by
  `git rebase origin/master`.
- Never work directly on the primary branch; keep a feature branch.
- Standard commit/push rules (§3) still apply — never commit/push without approval.
