---
name: frame
description: Turn a change request into a compact, testable entry contract before implementation starts.
disable-model-invocation: true
---

# Frame the change

Create a small contract that makes the implementation boundary reviewable. Do not implement the change in this skill.

## Procedure

1. Read repository instructions and the most relevant existing code or issue. Prefer `CLAUDE.md`, `AGENTS.md`, the current issue, and nearby tests.
2. Record the current base branch and full base commit SHA when Git is available. If it is not available, write `unavailable` instead of inventing a value.
3. Ask no more than two blocking questions. If a detail is useful but non-blocking, state a conservative assumption and continue.
4. Fill the contract at `${CLAUDE_PLUGIN_ROOT}/templates/entry-contract.md`.
5. Keep it human-sized:
   - one outcome sentence;
   - at most three non-goals;
   - three to seven observable acceptance checks;
   - only risks that could change the implementation or approval path.
6. Mark the entry `READY` only when the acceptance checks are testable, authority is clear, and the base SHA is recorded. Otherwise mark it `BLOCKED` and name the missing decision.

## Boundaries

- Do not turn the contract into a full product specification.
- Do not add adjacent cleanup unless it is required by an acceptance check.
- Do not silently expand scope after implementation starts. Re-run this skill when the requested outcome changes.
- Unless the user explicitly asks you to update a file or issue, return the filled contract in the conversation.
