# My Way of Working with AI Agents

These are my personal conventions for working with AI coding agents. They apply regardless of which tool I'm using (Rovo Dev, Claude Code, Gemini CLI, etc.).

## 1. Planning — Use `ck_*/` Directories

- When starting a non-trivial task, create a `ck_*/` plan directory (e.g., `ck_my-feature/`).
- These directories are **git-ignored globally** via `~/.gitignore` (`ck_*`) — they persist locally but are never committed. They are personal working space.
- Keep them after the task is complete — they serve as future reference.

**Structure:**
```
ck_feature/
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
