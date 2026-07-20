---
name: merge-gate
description: Reconcile verification and independent review at the final human merge gate without merging automatically.
disable-model-invocation: true
---

# Human merge gate

Turn the available evidence into a clear decision surface. The human remains the only merge or release authority.

## Procedure

1. Require the entry contract, verification record, and independent review verdict.
2. Record the current full HEAD SHA and worktree state. If the worktree is not clean, return `HOLD — UNCOMMITTED CHANGES` because those changes are covered by neither SHA-bound record.
3. Compare all recorded HEAD SHAs with the current full HEAD SHA.
4. If verification targeted a different SHA, return `HOLD — STALE VERIFICATION` and require verification of the current commit.
5. If the independent review targeted a different SHA, return `HOLD — STALE REVIEW`. Do not waive this because the later diff appears small.
6. Reconcile findings:
   - blocking findings still open;
   - non-blocking suggestions intentionally deferred;
   - acceptance checks and their latest evidence;
   - rollback or recovery notes for meaningful risk.
7. Fill `${CLAUDE_PLUGIN_ROOT}/templates/human-merge-decision.md`.
8. Return one recommendation:
   - `READY FOR HUMAN DECISION`: evidence is current and no blocker remains;
   - `REVISE`: a finding or failed check requires code changes;
   - `HOLD`: evidence, authority, or review freshness is incomplete.

## Authority boundary

- AI verification and reviewer approval are inputs, not the final decision.
- Never merge, release, deploy, or mark a PR ready solely because this skill returns `READY FOR HUMAN DECISION`.
- Name the exact residual risk so the human can make an informed choice.
