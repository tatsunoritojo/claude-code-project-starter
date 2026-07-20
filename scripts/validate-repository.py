#!/usr/bin/env python3
"""Validate the public package without third-party dependencies."""

from __future__ import annotations

import json
import re
import struct
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
EXPECTED_PLUGIN_SKILLS = {"frame", "verify", "review-brief", "merge-gate"}
EXPECTED_PLUGIN_TEMPLATES = {
    "entry-contract.md",
    "verification-record.md",
    "independent-review-brief.md",
    "human-merge-decision.md",
}
MARKDOWN_LINK = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
HTML_LINK = re.compile(r"(?:href|src|srcset)=\"([^\"]+)\"")


def fail(message: str) -> None:
    print(f"NG: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_json(path: Path) -> dict:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"{path.relative_to(ROOT)}: {exc}")


def require(condition: bool, message: str) -> None:
    if not condition:
        fail(message)


def frontmatter(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    require(text.startswith("---\n"), f"{path.relative_to(ROOT)}: frontmatter missing")
    parts = text.split("---", 2)
    require(len(parts) == 3, f"{path.relative_to(ROOT)}: frontmatter not closed")
    return parts[1]


def validate_marketplace() -> None:
    marketplace_path = ROOT / ".claude-plugin" / "marketplace.json"
    manifest_path = ROOT / "plugins" / "reliable-ship" / ".claude-plugin" / "plugin.json"
    marketplace = load_json(marketplace_path)
    manifest = load_json(manifest_path)

    require(marketplace.get("name") == "tojo-ai-workflows", "unexpected marketplace name")
    plugins = marketplace.get("plugins")
    require(isinstance(plugins, list) and len(plugins) == 1, "marketplace must list one plugin")
    entry = plugins[0]
    require(entry.get("name") == "reliable-ship", "marketplace plugin name mismatch")
    require(entry.get("source") == "./plugins/reliable-ship", "marketplace source mismatch")
    require(manifest.get("name") == entry.get("name"), "plugin manifest name mismatch")
    require(manifest.get("version") == entry.get("version"), "plugin version mismatch")


def validate_plugin_contents() -> None:
    plugin_root = ROOT / "plugins" / "reliable-ship"
    skills_root = plugin_root / "skills"
    templates_root = plugin_root / "templates"
    skills = {path.name for path in skills_root.iterdir() if path.is_dir()}
    templates = {path.name for path in templates_root.iterdir() if path.is_file()}

    require(skills == EXPECTED_PLUGIN_SKILLS, f"plugin skills: expected {sorted(EXPECTED_PLUGIN_SKILLS)}, got {sorted(skills)}")
    require(
        templates == EXPECTED_PLUGIN_TEMPLATES,
        f"plugin templates: expected {sorted(EXPECTED_PLUGIN_TEMPLATES)}, got {sorted(templates)}",
    )

    for name in sorted(skills):
        path = skills_root / name / "SKILL.md"
        require(path.is_file(), f"missing {path.relative_to(ROOT)}")
        metadata = frontmatter(path)
        for field in ("name:", "description:", "disable-model-invocation: true"):
            require(field in metadata, f"{path.relative_to(ROOT)}: {field} missing")
        require(
            "${CLAUDE_PLUGIN_ROOT}" in path.read_text(encoding="utf-8"),
            f"{path.relative_to(ROOT)}: packaged template path missing",
        )

    safety_tokens = {
        "verify": ("A `PASS` record requires a clean worktree", "Never attach a `PASS` record to HEAD"),
        "review-brief": ("Require a clean worktree", "exact HEAD"),
        "merge-gate": ("HOLD — UNCOMMITTED CHANGES", "HOLD — STALE REVIEW"),
    }
    for name, tokens in safety_tokens.items():
        text = (skills_root / name / "SKILL.md").read_text(encoding="utf-8")
        for token in tokens:
            require(token in text, f"skills/{name}/SKILL.md: safety rule missing: {token}")


def validate_project_template() -> None:
    required = [
        ROOT / "project-template" / "CLAUDE.md",
        ROOT / "project-template" / ".github" / "ISSUE_TEMPLATE" / "ai-change.yml",
        ROOT / "project-template" / ".github" / "PULL_REQUEST_TEMPLATE.md",
    ]
    for path in required:
        require(path.is_file(), f"missing {path.relative_to(ROOT)}")

    issue_form = required[1].read_text(encoding="utf-8")
    for token in ("id: outcome", "id: acceptance", "id: base_sha"):
        require(token in issue_form, f"{required[1].relative_to(ROOT)}: {token} missing")

    pr_template = required[2].read_text(encoding="utf-8")
    for token in ("Verified HEAD SHA", "Reviewed HEAD SHA", "Human merge gate"):
        require(token in pr_template, f"{required[2].relative_to(ROOT)}: {token} missing")

    mirrors = [
        (ROOT / ".github" / "ISSUE_TEMPLATE" / "ai-change.yml", required[1]),
        (ROOT / ".github" / "PULL_REQUEST_TEMPLATE.md", required[2]),
    ]
    for live, starter in mirrors:
        require(live.is_file(), f"missing {live.relative_to(ROOT)}")
        require(
            live.read_bytes() == starter.read_bytes(),
            f"{live.relative_to(ROOT)} and {starter.relative_to(ROOT)} must stay identical",
        )


def validate_visuals() -> None:
    for name in ("hero-light.svg", "hero-dark.svg", "workflow.svg"):
        path = ROOT / "assets" / name
        require(path.is_file(), f"missing {path.relative_to(ROOT)}")
        try:
            ET.parse(path)
        except ET.ParseError as exc:
            fail(f"{path.relative_to(ROOT)}: invalid SVG: {exc}")

    png = ROOT / "assets" / "social-preview.png"
    require(png.is_file(), f"missing {png.relative_to(ROOT)}")
    data = png.read_bytes()
    require(data[:8] == b"\x89PNG\r\n\x1a\n", "social-preview.png is not a PNG")
    width, height = struct.unpack(">II", data[16:24])
    require((width, height) == (1280, 640), f"social preview must be 1280x640, got {width}x{height}")


def validate_docs_and_evals() -> None:
    for readme in ("README.md", "README.ja.md"):
        text = (ROOT / readme).read_text(encoding="utf-8")
        require("reliable-ship@tojo-ai-workflows" in text, f"{readme}: install command missing")
        require("assets/hero-dark.svg" in text, f"{readme}: dark hero missing")

    scenarios = sorted((ROOT / "evals" / "scenarios").glob("*.md"))
    require(len(scenarios) == 5, f"expected 5 evaluation scenarios, got {len(scenarios)}")
    require((ROOT / "evals" / "results" / "template.csv").is_file(), "evaluation result template missing")
    require((ROOT / "docs" / "case-study-mackairu.md").is_file(), "public case study missing")

    docs = [
        ROOT / "README.md",
        ROOT / "README.ja.md",
        ROOT / "CONTRIBUTING.md",
        ROOT / "SECURITY.md",
        *sorted((ROOT / "docs").rglob("*.md")),
        *sorted((ROOT / "evals").rglob("*.md")),
    ]
    for path in docs:
        text = path.read_text(encoding="utf-8")
        require(text.count("```") % 2 == 0, f"{path.relative_to(ROOT)}: unclosed code fence")
        targets = MARKDOWN_LINK.findall(text) + HTML_LINK.findall(text)
        for raw_target in targets:
            target = raw_target.strip().split()[0].split("#", 1)[0]
            if not target or target.startswith(("http://", "https://", "mailto:", "#")):
                continue
            resolved = (path.parent / target).resolve()
            require(
                resolved == ROOT or ROOT in resolved.parents,
                f"{path.relative_to(ROOT)}: link escapes repository: {raw_target}",
            )
            require(resolved.exists(), f"{path.relative_to(ROOT)}: broken local link: {raw_target}")


def validate_legacy_pack() -> None:
    skills = sorted((ROOT / "home-claude" / "skills").glob("*/SKILL.md"))
    require(len(skills) == 14, f"full style pack must remain at 14 skills, got {len(skills)}")


def main() -> None:
    validate_marketplace()
    validate_plugin_contents()
    validate_project_template()
    validate_visuals()
    validate_docs_and_evals()
    validate_legacy_pack()
    print("OK: marketplace, plugin, templates, visuals, docs, evals, and legacy pack")


if __name__ == "__main__":
    main()
