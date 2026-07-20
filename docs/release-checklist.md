# v1.0 release checklist

The repository contains the assets and copy needed for launch. The settings below require a maintainer action in GitHub after the pull request is merged.

## Repository presentation

- **Description:** `A reviewable Claude Code workflow: frame the change, verify evidence, brief an independent reviewer, and keep merge authority human.`
- **Topics:** `claude-code`, `ai-coding`, `agentic-coding`, `code-review`, `human-in-the-loop`, `developer-tools`, `workflow`, `safety`
- **Social preview:** upload [`assets/social-preview.png`](../assets/social-preview.png) in **Settings → General → Social preview**
- **Homepage:** use the most relevant public guide or portfolio page only if it gives visitors a clearer next action than the README

## Release

- [ ] Merge the v1.0 pull request after CI and human review.
- [ ] Confirm both README themes render correctly on GitHub.
- [ ] Run `claude plugin validate .` with a current Claude Code installation.
- [ ] Add the marketplace from the merged default branch.
- [ ] Install `reliable-ship@tojo-ai-workflows` in a clean user scope.
- [ ] Run all four skills in a disposable repository.
- [ ] Tag `v1.0.0` and create release notes from `CHANGELOG.md`.
- [ ] Upload the social preview and apply the description/topics above.
- [ ] Link this repository from the profile README with the action text **Use this workflow**.

## First evidence cycle

- [ ] Run all five evaluation scenarios three times in both conditions.
- [ ] Preserve raw transcripts or stable links.
- [ ] Commit result CSVs without rewriting the protocol after seeing the outcome.
- [ ] Publish only claims the raw rows support.
