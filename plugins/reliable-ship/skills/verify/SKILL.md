---
name: verify
description: Verify a completed change against its acceptance contract and tie every claim to the current HEAD SHA.
disable-model-invocation: true
---

# Verify before "done"

Produce evidence for the change that exists now, not the change that was intended.

## Procedure

1. Locate the entry contract or ask the user to provide it. Do not reconstruct acceptance criteria from memory.
2. Record the full current HEAD SHA and `git status --short` output. A `PASS` record requires a clean worktree; uncommitted files are not part of the named commit.
3. Inspect the changed files and map each acceptance check to the smallest relevant proof.
4. Run the available build, lint, test, or focused reproduction commands that are proportionate to the risk. Capture the exact command and result.
5. Separate three categories:
   - **Verified**: directly supported by command output or inspected behavior;
   - **Not verified**: a relevant path that could not be exercised;
   - **Out of scope**: explicitly excluded by the entry contract.
6. Fill `${CLAUDE_PLUGIN_ROOT}/templates/verification-record.md`.
7. Return exactly one status:
   - `PASS`: every acceptance check has evidence and no blocking gap remains;
   - `FAIL`: at least one check has contradictory evidence;
   - `BLOCKED`: evidence is unavailable, the worktree is not clean, or the contract is missing.

## Evidence rules

- "Should work," compilation by inspection, and an agent's confidence are not evidence.
- A passing broad test suite does not prove an uncovered manual or production-only path.
- Never attach a `PASS` record to HEAD while tracked or untracked changes remain in the worktree.
- Never reuse a verification result after HEAD changes. Run the relevant checks again and issue a new record.
