# Reliable Ship — overview

Status: active

## What it solves

AI coding tools can implement quickly while leaving scope, proof, review freshness, and final authority implicit. Reliable Ship makes those boundaries visible through four gates: frame the change, verify the current commit, hand it to a separate reviewer, and leave the final merge or release decision to a human.

## Who it is for

- individual developers using Claude Code on software they intend to ship;
- small teams that want a reviewable AI workflow without adopting a large specification system;
- maintainers who use Claude Code for implementation and Codex or another separate context for adversarial review;
- people who need the same project-entry and handoff structure across repositories.

## Key concepts

- **Entry contract:** one outcome, explicit non-goals, observable acceptance checks, risk boundaries, and a base SHA.
- **Evidence record:** every completion claim maps to a command, test, or inspected behavior at an exact HEAD SHA.
- **Independent challenge:** the implementer's narrative becomes a neutral packet for a genuinely separate reviewer.
- **SHA freshness:** verification and approval do not carry forward after the reviewed commit changes.
- **Human authority:** AI outputs recommendations and evidence; a human owns merge and release.

## Distribution

- **Recommended:** `Reliable Ship` marketplace plugin with four Markdown skills and four templates. It includes no executable hooks or MCP servers.
- **Repository starter:** `project-template/` adds concise project memory, an overview, append-only ADRs, session context, and Issue/PR gates.
- **Advanced:** the legacy full style pack installs global Japanese rules, fourteen skills, settings, and a session-start greeting through non-destructive scripts.

## Evidence policy

The public MacKairu case study links observable commits and states its limitations. The evaluation kit publishes a fixed protocol and raw-result format before results. Behavioral benefit remains unmeasured until matched runs are committed.

## Related links

- Usage: [`README.md`](../README.md)
- Japanese guide: [`README.ja.md`](../README.ja.md)
- Case study: [`case-study-mackairu.md`](case-study-mackairu.md)
- Evaluation: [`evals/`](../evals/)
- Decisions: [`docs/decisions/`](decisions/)
