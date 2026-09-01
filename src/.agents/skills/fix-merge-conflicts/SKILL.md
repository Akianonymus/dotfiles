---
name: fix-merge-conflicts
description: Resolves git merge and rebase conflicts by researching each hunk with full diffs, auto-fixing obvious cases, and asking the user for ambiguous decisions. Use when the user mentions merge conflicts, rebase conflicts, conflict markers, or needs help finishing a merge/rebase/cherry-pick.
---

# Fix Merge Conflicts

Resolve merge/rebase/cherry-pick conflicts safely: research every conflict before acting, auto-resolve only when evidence is clear, ask the user for everything else.

## Principles

1. **Research before resolving** — never guess from conflict markers alone
2. **Diff everything** — base, ours, theirs, and the working tree for each hunk
3. **Auto-resolve only when obvious** — when in doubt, ask
4. **One file at a time** — finish research + resolution per file before moving on
5. **Verify before staging** — no leftover markers, file parses/lints if applicable
6. **Do not commit** unless the user explicitly asks

## Phase 1: Assess merge state

Run in parallel:

```bash
git status
git diff --name-only --diff-filter=U
git rev-parse --abbrev-ref HEAD
git log --oneline -3 MERGE_HEAD 2>/dev/null || git log --oneline -3 REBASE_HEAD 2>/dev/null || true
```

Determine:
- Operation type: merge, rebase, cherry-pick, or manual conflict
- Branch names: current (ours) vs incoming (theirs)
- Total conflicted files and whether any are binary

If no conflicts remain, report clean state and stop.

## Phase 2: Inventory

Build a conflict inventory before editing anything:

```
Conflict inventory:
- [ ] path/to/file.ts (3 hunks)
- [ ] path/to/other.py (1 hunk)
```

For each conflicted file, count hunks:

```bash
grep -c '^<<<<<<<' path/to/file || true
```

Group files by type (source, config, lockfile, docs, generated) — lockfiles and generated artifacts need extra caution.

## Phase 3: Research each conflict

For **each hunk in each file**, gather context before classifying. Run the research block below; read surrounding code in the file; check call sites if the hunk touches a public API.

### Research block (per file)

```bash
FILE="path/to/file"

# Three-way content
git show :1:"$FILE" 2>/dev/null | wc -l   # base (common ancestor)
git show :2:"$FILE" 2>/dev/null | wc -l   # ours (HEAD)
git show :3:"$FILE" 2>/dev/null | wc -l   # theirs (incoming)

# Focused diffs for this file
git diff :1:"$FILE" :2:"$FILE"    # base → ours
git diff :1:"$FILE" :3:"$FILE"    # base → theirs
git diff :2:"$FILE" :3:"$FILE"    # ours vs theirs (the actual disagreement)

# Who changed what recently
git log --oneline -5 -- "$FILE"
git log --oneline MERGE_HEAD -3 -- "$FILE" 2>/dev/null || git log --oneline REBASE_HEAD -3 -- "$FILE" 2>/dev/null || true
```

For the specific hunk, also inspect:
- Lines above/below the conflict in the working tree
- Imports, types, tests, and callers that depend on the changed symbols
- Whether one side is a pure rename/move and the other edited the old name

Summarize findings in one line before deciding:

```
Hunk 2/3 in src/auth.ts: ours adds retry logic; theirs renames `validate` → `verify`.
Both diverged from base. Not auto-resolvable — need user input.
```

See [reference.md](reference.md) for extended git commands and edge cases.

## Phase 4: Classify each hunk

### Auto-resolve (no user prompt)

Apply only when **all** conditions hold:

| Pattern | Resolution |
|---------|------------|
| Identical text on both sides | Keep either; remove markers |
| Whitespace / formatting only | Normalize to project style |
| One side matches base, other changed | Keep the side that changed |
| Both made the same logical change (e.g. same import, same rename) | Keep one copy |
| Trivial non-overlap (ours adds lines above, theirs adds below, no overlap) | Keep both changes |
| Generated file where project policy is clear (e.g. `package-lock.json` → regenerate) | Follow project convention, then verify |

Document each auto-resolution briefly:

```
Auto: kept theirs — only branch that modified this import; ours matched base.
```

### Ask the user (required)

Escalate when **any** of these apply:

- Both sides changed the same lines with different logic
- Delete/modify conflict (one deleted, one edited)
- API or behavior change on both sides
- Config/env values differ
- Lockfile conflict without a clear regen path
- Test expectations conflict
- Research summary is inconclusive
- Public interface changes on both sides

**Use `AskQuestion` when available.** Otherwise ask conversationally with the same options.

### Question format

Present structured choices per hunk (or per file if hunks are tightly coupled):

```
File: src/auth/service.ts — Hunk 1/2

Context: Base had `validate(token)`. Ours added retry + logging. Theirs renamed to `verify(token)` with new tests.

What should we keep?
1. Ours — retry + logging on `validate`
2. Theirs — `verify` rename + new tests
3. Both — rename to `verify` AND keep retry/logging
4. Other — I'll specify
```

For coupled hunks in the same file, one question covering the combined intent is fine.

## Phase 5: Apply resolution

1. Edit the file — remove all `<<<<<<<`, `=======`, `>>>>>>>` markers
2. Preserve project formatting and conventions
3. If combining both sides, ensure the result is syntactically and logically coherent
4. Re-read the resolved section — does it compile/read correctly in context?

For lockfiles after resolution:

```bash
# Example for npm — use the project's actual package manager
npm install --package-lock-only
```

For imports/types broken by the merge, fix downstream references in the same file before moving on.

## Phase 6: Verify

Per resolved file:

```bash
# No markers anywhere
git grep -n '<<<<<<<\|=======\|>>>>>>>' -- path/to/file

# Stage
git add path/to/file
```

After all files:

```bash
git diff --name-only --diff-filter=U   # must be empty
git grep -n '<<<<<<<\|=======\|>>>>>>>'  # must find nothing
git status
```

Run project checks if available and cheap (syntax, typecheck, relevant tests for touched areas). Fix issues introduced by the merge.

Report completion:

```
Resolved N files, M hunks:
- Auto: X hunks
- User decisions: Y hunks

Remaining: none. Staged and ready. Run `git commit` (merge) or `git rebase --continue` when ready.
```

Do **not** run `git commit`, `git merge --continue`, or `git rebase --continue` unless the user asks.

## Phase 7: Abort guidance

If conflicts are unrecoverable or the user wants to stop:

```bash
git merge --abort    # during merge
git rebase --abort   # during rebase
git cherry-pick --abort
```

Only suggest abort after explaining what will be lost.

## Anti-patterns

- Resolving from conflict markers without reading base/ours/theirs
- Batch-accepting "ours" or "theirs" for the whole repo
- Auto-resolving logic conflicts because one branch "looks newer"
- Staging files that still contain markers
- Committing without user request
- Ignoring binary conflicts (ask user — often pick one version or re-generate)

## Additional resources

- [reference.md](reference.md) — git stage syntax, binary files, rename detection, decision checklist
