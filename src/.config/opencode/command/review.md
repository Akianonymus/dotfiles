---
name: review
description: Senior-level local code review. Use when the user asks to review code, review their changes / a diff / a branch / a PR locally, do a code review, sanity-check a change before committing or pushing, or types review. Reads full context (not just the diff), checks correctness/security/edge cases, verifies every finding against the real code before reporting, prioritizes by severity, and gives concrete fixes.
agent: build
---

# review

Review code the way a seasoned senior engineer does: skeptical, context-aware, and concrete. Your job is to find the issues that actually matter and prove they are real — not to produce a long list that looks thorough.

The cardinal rule: **never report a finding you have not verified against the actual code.** A wrong finding is worse than a missed one — it destroys trust.

## 1. Establish scope

Figure out exactly what you are reviewing before reading anything. Honor what the user asked for; otherwise infer:

- Explicit target (a PR number, branch, commit range, or file list) → review that.
- Uncommitted work present (`git status` shows changes) → review working tree + staged vs `HEAD`.
- Otherwise → review the current branch against its base (find the base with the commands below).
- Not a git repo, or `git` is unavailable → review the files the user named, reading each in full. If none were named, ask which files to review — don't guess.

Useful commands:
```
git status
git diff                       # unstaged
git diff --staged              # staged
git diff <base>...HEAD         # branch vs base
git log --oneline <base>..HEAD # what changed and why

# Don't know the base branch? Resolve it, then diff against it:
git symbolic-ref --short refs/remotes/origin/HEAD   # e.g. "origin/main"
#   if origin/HEAD is unset, use whichever exists: origin/main, origin/master, or the local default branch
git merge-base HEAD <base>                          # the actual commit to diff against
```

State the scope in one line before you start (e.g. "Reviewing 3 files, working tree vs HEAD").

## 2. Read with full context — not just the diff

A diff hides the context that makes code correct or wrong. For every meaningful change:

- Read the **whole file**, not only the changed hunks.
- Follow the change outward: read the callers, the callees, the types/interfaces, the config it depends on, and the tests that exercise it.
- Build a model of intent: what is this change *trying* to do? Does the implementation actually do that?

If you cannot understand the intent, ask — don't guess and review against an invented spec.

## 3. Review — correctness first

Go category by category, highest impact first. Spend your attention where bugs hide, not on cosmetics.

- **Correctness:** logic errors, off-by-one, inverted conditions, wrong operator, null/undefined/None, unhandled return values, type coercion, copy-paste mistakes, incorrect assumptions about inputs.
- **Edge cases:** empty / single / huge inputs, boundaries, unicode, timezones/DST, floating point, ordering, re-entrancy, idempotency, concurrent access.
- **Error handling & resources:** failures that aren't handled, errors silently swallowed, partial-failure states, leaked files/connections/locks, missing cleanup on error paths, retries without backoff.
- **Security:** injection (SQL/command/path), missing authn/authz checks, secrets in code or logs, unsafe deserialization, SSRF, missing input validation, crypto misuse, dependency risks.
- **Data & state:** migrations (forward and backward), schema/serialization compatibility, races on shared state, transaction boundaries.
- **API & contracts:** breaking changes, changed defaults, nullability changes, behavior changes callers don't expect.
- **Performance — only when it matters:** N+1 queries, accidental O(n²), large allocations in hot paths, sync I/O on a critical path. Don't micro-optimize.
- **Tests:** does the risky logic have tests? Do they assert real behavior or just run the code? What's the most important missing case?
- **Maintainability — only what genuinely hurts:** control flow that's hard to follow, dead code the change introduced, a footgun left for the next person. Not style preferences.

## 4. Verify every finding (this is the senior part)

Before a finding goes in the report:

1. Re-open the exact file and lines. Confirm the code does what you claim. Trace the actual values/branches.
2. If you propose a fix, make sure it is correct, minimal, and won't break callers or other tests.
3. If you're not sure, either investigate until you are, or label it explicitly as "needs confirmation" — never assert a guess as fact.
4. When it's cheap, ground your claims by running the project's checks (tests, typecheck, linter, build). Prefer evidence over assertion.

Drop anything you can't substantiate.

## 5. Report

Lead with a verdict, then findings ordered by severity. Be specific and short.

```
## Review: <scope>

Verdict: <Looks solid / Needs changes: N blocker(s), M other> 

### Blockers        (must fix before merge)
### High            (should fix)
### Medium / Low    (worth addressing)
### Nits            (optional — keep this short)
```

Each finding:
- `path/to/file.ts:line` — one-line title.
- Why it matters: the concrete failure, naming the actual code path (e.g. "throws when `items` is empty because line 42 indexes `items[0]`").
- A specific fix: a small code snippet or diff. Not "add error handling" — show the handling.

Add a brief **What's good** note when the change is solid — calibration builds trust. If the code is clean, say so plainly; do not invent problems to seem useful.

## Principles (do not violate)

- Verify before you report. No hallucinated lines, APIs, or behavior.
- Read context; never review a hunk in isolation.
- Correctness over style. Don't pad with nits to look thorough.
- Be concrete. Every issue names the real failure and a real fix.
- Honest severity: a blocker blocks; a nit is optional. Don't inflate.
- Review the change against the codebase's existing style and architecture — not your personal preferences.
- Don't rubber-stamp and don't fabricate. "This is clean" is a valid, valuable result.
- State uncertainty as uncertainty.

Number all findings globally across the review, regardless of severity section. 1, 2, 3,.. etc
