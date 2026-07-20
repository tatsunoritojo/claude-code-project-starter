# Security policy

## What installs

The recommended `Reliable Ship` plugin contains Markdown skills and templates only. It does not ship hooks, MCP servers, executables, network clients, or background processes.

The optional full style pack is broader. Its installers write rules, skills, settings, and one session-start hook under `~/.claude/`. Read the scripts before running them in a sensitive environment.

## Safety properties of the full installer

- Existing `CLAUDE.md` and `settings.json` are preserved by default.
- Same-name skills are skipped unless force is explicit.
- A same-name session hook is also skipped unless force is explicit.
- Forced replacements are backed up.
- The install manifest limits automatic uninstall targets.
- Uninstall rejects manifest paths outside the expected `skills/` and `hooks/` entries.
- Uninstall is a dry run until explicit confirmation.
- The scripts do not download or execute remote content.

## Supported versions

Security fixes are applied to the latest released plugin version and the current default branch. Older snapshots may not receive backports.

## Reporting a vulnerability

Do not publish secrets, private repository details, or an exploitable proof of concept in a public Issue.

Use GitHub's private vulnerability reporting for this repository when available. If that option is unavailable, open a minimal public Issue asking the maintainer for a private reporting channel and omit sensitive details.

Include:

- affected version or commit SHA;
- affected installation path (plugin or full style pack);
- impact and prerequisites;
- the smallest safe reproduction;
- suggested mitigation, if known.
