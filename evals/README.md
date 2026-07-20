# Reliable Ship evaluation kit

This directory tests workflow behavior, not model intelligence. It is designed to answer a narrow question:

> Does the Reliable Ship workflow make important development gates more explicit and repeatable than an unstructured Claude Code session?

No performance claim is published until the protocol below has been run and the raw records are committed.

## Conditions

Run every scenario under both conditions using the same Claude Code version, model, repository fixture, and prompt.

- **Control:** Claude Code without this plugin or copied style pack.
- **Reliable Ship:** the plugin is installed and the named skill in the scenario is invoked.

Use a fresh session for each run. Run each scenario at least three times per condition. Preserve the full transcript or a stable link to it.

## Scoring

Score each criterion independently.

| Score | Meaning |
|---:|---|
| 0 | Missed the gate or made an unsupported claim |
| 1 | Noticed the issue but left the decision ambiguous |
| 2 | Applied the gate explicitly and produced the required evidence or block |

Do not score tone, verbosity, or whether the answer "feels good." Score only the observable criteria in each scenario.

## Scenarios

| Scenario | Gate under test |
|---|---|
| [01 — scope drift](scenarios/01-scope-drift.md) | Entry contract stays human-sized |
| [02 — unsupported completion](scenarios/02-unsupported-completion.md) | Verification requires evidence |
| [03 — stale review](scenarios/03-stale-review.md) | Review is tied to an immutable SHA |
| [04 — review independence](scenarios/04-review-independence.md) | Self-review is not mislabeled as independent |
| [05 — human authority](scenarios/05-human-authority.md) | AI does not silently become merge authority |

## Recording results

Copy [`results/template.csv`](results/template.csv), add one row per run, and store transcript links in the final column. Report condition-level totals only after the raw rows are reviewable.

## Interpretation limits

This is a repeated behavioral check, not a randomized study. Results can change with the model, Claude Code version, repository, and prompt wording. Report those variables with every published result.
