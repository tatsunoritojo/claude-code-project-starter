# Contributing to Claude Code Project Starter

Thank you for your interest in contributing! This document provides guidelines for contributing to this template.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in [GitHub Issues](https://github.com/YOUR_USERNAME/claude-code-project-starter/issues)
2. If not, create a new issue with:
   - Clear, descriptive title
   - Detailed description of the problem or suggestion
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (OS, Claude Code version, etc.)

### Suggesting Enhancements

We welcome suggestions for:

- New skills or workflows
- Improved documentation
- Better project templates
- Additional language/framework support

Please create an issue with the `enhancement` label.

### Pull Requests

1. **Fork the repository**

```bash
gh repo fork YOUR_USERNAME/claude-code-project-starter
```

2. **Create a feature branch**

```bash
git checkout -b feature/your-feature-name
```

3. **Make your changes**

Follow the commit conventions:

```bash
git commit -m "feat(skills): add Python project conventions"
git commit -m "docs(readme): improve installation instructions"
git commit -m "fix(setup): resolve Windows path issues"
```

4. **Test your changes**

- Run the setup script
- Verify all files are created correctly
- Test with Claude Code
- Check documentation accuracy

5. **Push and create PR**

```bash
git push origin feature/your-feature-name
gh pr create --title "feat(skills): add Python project conventions"
```

## Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Scopes

- `skills`: Changes to skill files
- `setup`: Setup scripts
- `docs`: Documentation
- `template`: Template structure
- `hooks`: Claude Code hooks

### Examples

```bash
feat(skills): add Go project conventions
fix(setup): resolve macOS permissions issue
docs(readme): add Windows installation steps
chore(template): update .gitignore patterns
```

## Development Guidelines

### File Structure

Maintain the template structure:

```
claude-code-project-starter/
├── .claude/
│   ├── hooks/
│   ├── skills/
│   └── settings.json
├── docs/
├── scripts/
├── CLAUDE.md
└── README.md
```

### Documentation

- Update `README.md` for user-facing changes
- Update `CLAUDE.md` for project standard changes
- Update `docs/CLAUDE_CODE_ONBOARDING.md` for workflow changes
- Add inline comments for complex logic

### Code Quality

- Scripts should work on Linux, macOS, and Windows (where applicable)
- Test setup scripts in clean environments
- Ensure all paths use cross-platform conventions
- Validate JSON files (settings.json)
- Check YAML frontmatter in SKILL.md files

### Testing Checklist

Before submitting a PR:

- [ ] Setup script runs without errors
- [ ] All files are created correctly
- [ ] .gitignore patterns work as expected
- [ ] Skills load in Claude Code
- [ ] Documentation is accurate and clear
- [ ] Commit messages follow conventions
- [ ] No sensitive data in commits

## Skill Development

### Creating New Skills

When adding new skills to the template:

1. **Create the skill directory**

```bash
mkdir -p .claude/skills/your-skill-name
```

2. **Write SKILL.md**

```yaml
---
name: your-skill-name
description: Clear description of what this skill does and when to use it
allowed-tools: Bash(npm:*), Read, Write
---

# Skill Name

## Overview
[Brief description]

## Quick Start
[Common usage examples]

## Detailed Guide
[Step-by-step instructions]
```

3. **Test the skill**

```bash
# In Claude Code:
What Skills are available?

# Should show your new skill
```

4. **Document the skill**

- Add to README.md
- Add usage examples
- Update CLAUDE_CODE_ONBOARDING.md

### Skill Best Practices

- **Focus**: One skill = one responsibility
- **Description**: Be specific about when to use it
- **Tools**: Only request necessary tools
- **Documentation**: Include examples
- **Testing**: Verify it works in real projects

## Code Review Process

### For Contributors

Your PR will be reviewed for:

- Code quality and style
- Documentation completeness
- Testing coverage
- Cross-platform compatibility
- Adherence to conventions

### For Reviewers

When reviewing PRs:

- Check functionality on multiple platforms
- Verify documentation accuracy
- Test setup scripts
- Ensure commit messages follow conventions
- Provide constructive feedback

## Release Process

Maintainers will:

1. Review and merge approved PRs
2. Update version numbers (if applicable)
3. Update CHANGELOG.md
4. Create release notes
5. Tag releases with semantic versioning

## Questions?

- 💬 **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/claude-code-project-starter/discussions)
- 📧 **Email**: your.email@example.com
- 💼 **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/claude-code-project-starter/issues)

## Code of Conduct

Be respectful, inclusive, and constructive. We're all here to build better tools together.

---

Thank you for contributing! 🙏
