# Contributing

Reliable Ship is deliberately small. Contributions are welcome when they make a gate clearer, safer, easier to verify, or easier to adopt.

## Good contributions

- a reproducible bug in a packaged skill or template;
- a smaller wording change that removes ambiguity;
- a new evaluation run with raw records and transcript links;
- a scenario that exposes a real workflow failure not covered today;
- installation or accessibility improvements;
- a translation that preserves the authority and evidence boundaries.

Large agent frameworks, hidden automation, product-specific rules, and unmeasured performance claims are out of scope.

## Before opening a pull request

1. Keep one change in one PR.
2. Explain the outcome and explicit non-goals.
3. Run:

   ```bash
   python3 scripts/validate-repository.py
   bash scripts/check-anonymization.sh
   shellcheck -S error install.sh uninstall.sh scripts/*.sh home-claude/hooks/*.sh project-template/.claude/hooks/*.sh
   ```

4. If you change plugin behavior, add or update an evaluation scenario.
5. If you change a public claim, link the raw evidence.
6. If you change a design decision, add a new ADR. Do not rewrite earlier decisions.

## Versioning

Plugin releases use semantic versions. Keep the version in these files aligned:

- `.claude-plugin/marketplace.json`
- `plugins/reliable-ship/.claude-plugin/plugin.json`

## Review expectations

Review should verify:

- the current HEAD, not only a branch name;
- whether any skill silently expands authority;
- whether “verified” statements have direct evidence;
- whether the full style pack remains backward compatible.
