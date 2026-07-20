# 0002. Package the public workflow as a Claude Code plugin

Date: 2026-07-20

## Status

Accepted

## Context

The repository already distributed a safe global style pack with fourteen skills and non-destructive installers. Its public entry point, however, described configuration rather than a distinct workflow, required cloning and copying files, defaulted to Japanese, and did not provide a direct artifact for the four-stage process shown on the maintainer's profile.

Claude Code now supports versioned plugins and Git-backed plugin marketplaces. The existing installer remains useful for people who want the full global rules, but it is too broad to be the first experience for a new visitor.

## Decision

Make `Reliable Ship` the primary public product:

- distribute four explicit workflow gates as a marketplace plugin;
- use English as the default public documentation and provide a complete Japanese README;
- preserve the existing fourteen-skill style pack as an advanced, backward-compatible installation path;
- add Issue and pull request templates to the project starter;
- publish a real public case study and a reproducible evaluation protocol;
- make visual assets part of the repository rather than relying on external image hosting.

## Consequences

- Positive: a visitor can understand and install the differentiating workflow in minutes.
- Positive: plugin installation is versioned, namespaced, reversible, and aligned with current Claude Code distribution.
- Positive: the independent-review and human-merge boundaries become executable templates rather than profile-page claims.
- Negative: the repository now supports two installation paths, so documentation and CI must keep their scopes distinct.
- Negative: behavioral benefit remains unmeasured until the evaluation protocol is run; the repository must not imply otherwise.
