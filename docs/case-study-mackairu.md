# Case study: changing MacKairu without losing control

This is an evidence trail, not a claim that one workflow caused a percentage improvement.

[MacKairu](https://github.com/tatsunoritojo/MacKairu) is a native SwiftUI/AppKit desktop mascot with AI chat, vision input, multiple model providers, and interaction-heavy UI. That mix makes apparently small changes risky: IME behavior, window lifecycle, animation state, and API handling can regress independently.

## The change sequence

In June 2026, one change sequence fixed Japanese IME input and split two oversized UI/state files while preserving behavior.

| Public evidence | What it records | Gate demonstrated |
|---|---|---|
| [IME fix](https://github.com/tatsunoritojo/MacKairu/commit/9f6d2d991ce2fd1a80aad3ae345239e3c7cf92cc) | Guards SwiftUI-to-NSTextView synchronization while marked text is active | A concrete defect and reproduction boundary |
| [RootView split](https://github.com/tatsunoritojo/MacKairu/commit/92c95856aa928b78ab2a3a5dc53dd6f8dbaf16ea) | Splits a 666-line view, reports a green build and 58 tests, and records Codex review | Small implementation phase + evidence |
| [AppModel split](https://github.com/tatsunoritojo/MacKairu/commit/e9d030a522973cc9561b6b9904c1529df6430e57) | Separates a 1,196-line state object by responsibility without an intended behavior change | Explicit non-goal: no behavior change |
| [Pure logic extraction](https://github.com/tatsunoritojo/MacKairu/commit/4eea1282934388faa777d3c190a77f06906d6c6d) | Moves geometry and load thresholds into testable types; test count moves from 58 to 69 | Verification surface improves |
| [Combined merge](https://github.com/tatsunoritojo/MacKairu/commit/1aa3cb2a8c539a6bce9b49e605d1e1392da6e616) | Records the integrated scope, passing phases, and review statement | Separate integration checkpoint |

## How Reliable Ship models this

### 1. Frame

- **Outcome:** Japanese text composition works, and large files become easier to change.
- **Non-goal:** do not alter existing mascot behavior during the structural phases.
- **Acceptance evidence:** focused IME behavior, successful build, existing tests, and new unit coverage for extracted logic.

### 2. Verify

Each phase records what was actually checked. Structural commits report build and test results; the logic extraction adds direct unit tests instead of relying only on UI behavior.

### 3. Review independently

The public commit messages record Codex review. Reliable Ship makes the next iteration stricter by requiring a review brief and an exact reviewed HEAD SHA, so a later commit cannot silently inherit an earlier approval.

### 4. Let a human decide

The combined merge is distinct from the implementation phases. That separation is the point: implementation evidence and reviewer findings inform the merge; they do not perform it.

## What this evidence does not prove

- The history is observational, not a controlled experiment.
- Commit messages state that Codex review occurred, but the full review transcripts are not public artifacts.
- Test counts show a wider automated surface, not complete behavioral coverage.
- No speed, defect-reduction, or productivity percentage should be inferred.

The evaluation kit in [`evals/`](../evals/) exists so future claims can be attached to a fixed protocol and raw runs rather than memory.
