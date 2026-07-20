---
name: review-brief
description: Build a self-contained review packet for an independent reviewer such as Codex, anchored to one immutable commit.
disable-model-invocation: true
---

# Prepare the independent review

Create the smallest packet another reviewer needs to challenge the change without inheriting the implementer's assumptions.

## Procedure

1. Require an entry contract and a `PASS` verification record. If either is missing or verification did not pass, stop with `BLOCKED`.
2. Record the base SHA and the exact full HEAD SHA to review.
3. Require a clean worktree and confirm that the verification record names that exact HEAD. If the worktree is dirty or HEAD moved after verification, stop and request a clean commit plus re-verification.
4. Summarize intent, changed surfaces, acceptance evidence, risky decisions, and known gaps. Link to the diff or PR when available.
5. Add explicit questions that invite refutation, including correctness, security, regression, scope drift, and missing tests where relevant.
6. Fill `${CLAUDE_PLUGIN_ROOT}/templates/independent-review-brief.md`.

## Independence rules

- Do not label Claude's self-review as independent review.
- Do not tell the reviewer that the change is good or ready. Ask for a verdict supported by findings.
- Ask the reviewer to report the reviewed HEAD SHA and distinguish blocking findings from suggestions.
- The packet may be handed to Codex or another separate reviewer; this skill does not impersonate that reviewer.
