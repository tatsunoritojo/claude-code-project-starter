---
name: git-github-workflow
description: Manages Git commits, branches, and GitHub PR workflows following best practices. Use when working with git operations, creating commits, managing branches, opening pull requests, or performing code reviews. Automatically applies Conventional Commits standards and ensures clean Git history.
allowed-tools: Bash(git:*), Bash(gh:*), Read, Glob, Grep, Edit
model: sonnet
---

# Git/GitHub Workflow Management

## Overview

This Skill provides comprehensive Git and GitHub workflow management following industry best practices. It ensures consistent commit messages, proper branching strategy, and streamlined PR workflows across all your projects.

## Core Principles

1. **Conventional Commits** - Standardized commit message format
2. **Clean History** - Meaningful, atomic commits
3. **Branch Strategy** - Organized feature development
4. **Code Review** - Quality assurance through PRs
5. **Automation** - Reduce manual errors

## Quick Reference

### Making a Commit

**Standard Workflow:**

```bash
# 1. Review changes
git status
git diff

# 2. Stage selective changes
git add <files>

# 3. Create commit with proper message
git commit -m "type(scope): subject"
```

**Commit Message Format:**

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code restructuring without behavior change
- `perf`: Performance improvement
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependencies

**Examples:**

```bash
# Feature
git commit -m "feat(auth): add OAuth2 login support"

# Bug fix
git commit -m "fix(search): prevent crash on empty query"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Chore
git commit -m "chore(deps): update dependencies to latest versions"
```

### Branch Naming Convention

**Format:** `<type>/<short-description>`

```bash
# Feature branches
git checkout -b feature/add-user-profile
git checkout -b feature/oauth-integration

# Bug fixes
git checkout -b fix/login-validation
git checkout -b fix/memory-leak

# Documentation
git checkout -b docs/api-reference

# Chores
git checkout -b chore/update-dependencies
```

### Pull Request Workflow

**Creating a PR:**

```bash
# 1. Ensure branch is up to date
git fetch origin
git rebase origin/main

# 2. Push to remote
git push origin feature/my-feature

# 3. Create PR with gh CLI
gh pr create --title "feat(module): description" --body "Detailed description"
```

**PR Title Format:**

Same as commit messages:
```
type(scope): Brief description
```

**PR Description Template:**

```markdown
## Summary
Brief overview of changes

## Changes
- Change 1
- Change 2
- Change 3

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Screenshots (if applicable)
[Add screenshots]

## Related Issues
Closes #123
Related to #456
```

## Detailed Workflows

### Workflow 1: Feature Development

```bash
# 1. Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/new-feature

# 2. Make changes iteratively
# ... edit files ...
git add <files>
git commit -m "feat(module): implement core functionality"

# ... more edits ...
git add <files>
git commit -m "feat(module): add error handling"

# 3. Keep branch updated with main
git fetch origin
git rebase origin/main

# 4. Push and create PR
git push origin feature/new-feature
gh pr create --title "feat(module): add new feature" \
  --body "$(cat <<EOF
## Summary
Implements new feature X

## Changes
- Core functionality
- Error handling
- Unit tests

## Testing
- [x] All tests pass
- [x] Manual testing complete

Closes #123
EOF
)"
```

### Workflow 2: Bug Fix

```bash
# 1. Create fix branch
git checkout main
git pull origin main
git checkout -b fix/issue-description

# 2. Fix and test
# ... fix the bug ...
git add <files>
git commit -m "fix(component): resolve issue description

Detailed explanation of the fix and root cause.

Fixes #456"

# 3. Push and create PR
git push origin fix/issue-description
gh pr create --title "fix(component): resolve issue description"
```

### Workflow 3: Project Cleanup

**After PR is merged:**

```bash
# 1. Update main
git checkout main
git pull origin main

# 2. Delete local merged branch
git branch -d feature/merged-feature

# 3. Delete remote branch (if not auto-deleted)
git push origin --delete feature/merged-feature

# 4. Prune remote references
git fetch --all --prune
```

**Bulk cleanup:**

```bash
# List merged branches
git branch --merged main

# Delete all merged branches except main
git branch --merged main | grep -v "main" | xargs git branch -d

# Clean up remote tracking branches
git remote prune origin
```

### Workflow 4: Code Review

**As Reviewer:**

```bash
# 1. Fetch PR
gh pr checkout <PR-number>

# 2. Review changes
git diff main...HEAD

# 3. Test locally
npm test  # or appropriate test command

# 4. Leave review
gh pr review <PR-number> --approve
# or
gh pr review <PR-number> --request-changes --body "Comments..."
```

## Advanced Operations

### Amending Last Commit

```bash
# Add forgotten changes to last commit
git add <forgotten-file>
git commit --amend --no-edit

# Edit last commit message
git commit --amend
```

**⚠️ Warning:** Only amend commits that haven't been pushed yet.

### Interactive Rebase (Clean History)

```bash
# Clean up last 3 commits
git rebase -i HEAD~3

# In editor, you can:
# - pick: keep commit as-is
# - reword: change commit message
# - squash: combine with previous commit
# - drop: remove commit
```

**⚠️ Warning:** Only rebase commits that haven't been pushed yet.

### Resolving Conflicts

```bash
# During merge or rebase
git status  # See conflicted files

# Edit conflicted files, then:
git add <resolved-files>
git rebase --continue  # if rebasing
# or
git merge --continue   # if merging
```

### Stashing Work in Progress

```bash
# Save current changes
git stash push -m "WIP: feature description"

# List stashes
git stash list

# Apply stash
git stash pop

# Apply specific stash
git stash apply stash@{0}
```

## Safety Checks

### Pre-Commit Checklist

Before committing, ensure:

- [ ] Code compiles/runs without errors
- [ ] Tests pass (`npm test` or equivalent)
- [ ] Code is formatted (`npm run format` or equivalent)
- [ ] No sensitive data (API keys, passwords, .env files)
- [ ] Commit message follows Conventional Commits
- [ ] Changes are atomic (one logical change per commit)

### Pre-Push Checklist

Before pushing:

- [ ] All commits have meaningful messages
- [ ] Branch is rebased on latest main
- [ ] All tests pass
- [ ] No debug code or console.logs
- [ ] Documentation updated if needed

### Pre-PR Checklist

Before creating PR:

- [ ] PR title follows convention
- [ ] Description is clear and complete
- [ ] Related issues are linked
- [ ] Tests are included
- [ ] No merge conflicts with main
- [ ] CI/CD checks will pass

## Git Configuration Best Practices

### Recommended Git Config

```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Better diff output
git config --global diff.algorithm histogram

# Auto-prune on fetch
git config --global fetch.prune true

# Default branch name
git config --global init.defaultBranch main

# Rebase on pull
git config --global pull.rebase true

# Auto-stash before rebase
git config --global rebase.autoStash true
```

### Useful Aliases

```bash
# Status shorthand
git config --global alias.s status

# Commit shorthand
git config --global alias.c commit

# Pretty log
git config --global alias.lg "log --graph --oneline --decorate --all"

# Amend last commit
git config --global alias.amend "commit --amend --no-edit"

# List branches by date
git config --global alias.recent "branch --sort=-committerdate"
```

## Troubleshooting

### "Detached HEAD" State

```bash
# Create branch from current position
git checkout -b recovery-branch

# Or return to main
git checkout main
```

### Undo Last Commit (Keep Changes)

```bash
git reset --soft HEAD~1
```

### Undo Last Commit (Discard Changes)

```bash
git reset --hard HEAD~1
```

**⚠️ Warning:** This permanently deletes changes.

### Force Push After Rebase

```bash
# Only if you're sure no one else is using the branch
git push --force-with-lease origin feature/my-branch
```

**⚠️ Warning:** Never force push to main or shared branches.

## Integration with Project Standards

This Skill reads project-specific conventions from:

1. **CLAUDE.md** - Project standards
2. **.github/CONTRIBUTING.md** - Contribution guidelines
3. **Project's commit history** - Learn from existing patterns

Always check the project's documentation for specific requirements that may override these defaults.

### ADR Files: Always Use Feature Branch + PR

ADR (Architecture Decision Records under `docs/decisions/NNNN-*.md`) are **never** committed directly to main, even though they are docs-only changes.

**Rationale (from user feedback):**
> docs-only でも main 直コミットより PR 履歴の方が価値が高い。
> ADR は単なるメモではなく、設計意思決定の固定。
> どのレビューを経て Accepted になったか / どの修正で確定したか / 実装が
> どの ADR 版に従っているか — これを後で追えるようにするには PR 単位の
> 区切りが必要。

**Workflow for ADR commits:**

1. Create feature branch named `docs/adr-NNNN-<short-name>` or `feat/<scope>-adr-NNNN-NNNN`
2. Commit the ADR (typically with `docs:` prefix)
3. If implementing the ADR in the same PR, add follow-up commits in the same branch
4. Open PR with explicit annotation in description:
   - Which ADRs are being Accepted in this PR
   - Whether implementation is included or deferred
5. Squash-merge after review

**Example PR titles for ADR work:**
- `docs(adr): スキーマ整合性ガバナンスの ADR 0001/0002 を起票`
- `feat(schema-governance): ADR 0001/0002 確定 + Step 1 (可視化のみ)`

**Exceptions (when direct main commit is acceptable):**
- Only typo fixes / formatting in already-Accepted ADRs
- Never for adding new ADRs or changing Status

This rule applies even for solo development — the PR history acts as the audit trail for design decisions, which has long-term value.

## Example: Complete Feature Workflow

```bash
# Start new feature
git checkout main
git pull origin main
git checkout -b feature/user-authentication

# Implement core auth
# ... edit files ...
git add src/auth/
git commit -m "feat(auth): implement basic authentication

- Add login/logout endpoints
- Create JWT token generation
- Add password hashing with bcrypt"

# Add tests
# ... create tests ...
git add tests/auth/
git commit -m "test(auth): add authentication tests

- Test login success/failure
- Test token validation
- Test password hashing"

# Update documentation
# ... edit docs ...
git add docs/
git commit -m "docs(auth): add authentication guide

Explain how to use the new authentication system"

# Sync with main
git fetch origin
git rebase origin/main

# Push and create PR
git push origin feature/user-authentication

gh pr create \
  --title "feat(auth): implement user authentication" \
  --body "$(cat <<EOF
## Summary
Implements complete user authentication system with JWT tokens.

## Changes
- Basic login/logout endpoints
- JWT token generation and validation
- Password hashing with bcrypt
- Comprehensive test coverage
- Documentation

## Testing
- [x] All unit tests pass (95% coverage)
- [x] Integration tests pass
- [x] Manual testing completed
- [x] Security review completed

## Security Considerations
- Passwords hashed with bcrypt (cost factor 12)
- JWTs signed with RS256
- Tokens expire after 24 hours
- Refresh token rotation implemented

Closes #234
EOF
)"

# After approval and merge, cleanup
git checkout main
git pull origin main
git branch -d feature/user-authentication
git remote prune origin
```

## Quick Command Reference

| Task | Command |
|------|---------|
| Create branch | `git checkout -b type/description` |
| Commit | `git commit -m "type(scope): subject"` |
| Update from main | `git fetch origin && git rebase origin/main` |
| Push branch | `git push origin branch-name` |
| Create PR | `gh pr create --title "..." --body "..."` |
| Cleanup merged | `git branch -d branch-name` |
| View history | `git log --graph --oneline --all` |
| Stash changes | `git stash push -m "description"` |

---

**Note:** This Skill automatically adapts to project-specific conventions defined in CLAUDE.md or .github/CONTRIBUTING.md. Always check project documentation for specific requirements.
