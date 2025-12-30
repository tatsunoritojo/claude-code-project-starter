# Claude Code Onboarding Guide

Welcome to AI-driven development with Claude Code! This guide will help you get started with using Claude Code effectively in this project.

## 📋 Table of Contents

- [What is Claude Code?](#what-is-claude-code)
- [Installation](#installation)
- [Project Setup](#project-setup)
- [Available Skills](#available-skills)
- [Common Workflows](#common-workflows)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## What is Claude Code?

Claude Code is an AI-powered development assistant that helps with:

- **Code Generation**: Writing boilerplate, components, and logic
- **Git/GitHub Operations**: Commits, branches, PRs with proper conventions
- **Code Review**: Analyzing code quality and suggesting improvements
- **Documentation**: Generating and updating docs
- **Debugging**: Identifying and fixing issues
- **Testing**: Writing and maintaining tests

### Why We Use It

- ✅ Consistent code quality across the team
- ✅ Automated adherence to project conventions
- ✅ Faster development cycles
- ✅ Better documentation
- ✅ Reduced cognitive load on repetitive tasks

## Installation

### Prerequisites

- Node.js 18+ and npm
- Git
- GitHub CLI (`gh`) - Optional but recommended

### Step 1: Install Claude Code

Follow the [official installation guide](https://code.anthropic.com/install).

### Step 2: Configure Project

After cloning this repository:

**Option A: Automatic Setup (Recommended)**

```bash
# For Linux/Mac
bash scripts/setup-claude-code.sh

# For Windows (PowerShell)
.\scripts\setup-claude-code.ps1
```

**Option B: Manual Setup**

1. Verify `.claude/` directory exists
2. Review `CLAUDE.md` for project standards
3. Ensure `.claude/settings.json` has correct permissions

### Step 3: Verify Installation

Start Claude Code in the project directory:

```bash
cd habit-tracker
claude
```

In the Claude Code prompt, type:

```
What Skills are available?
```

You should see:
- `git-github-workflow` (Personal Skill - all projects)
- `project-conventions` (Project Skill - this project only)

## Project Setup

### Understanding the Configuration

This project has two levels of Claude Code configuration:

#### 1. Personal Skills (`~/.claude/skills/`)

Global skills available in **all your projects**:

```
~/.claude/skills/
└── git-github-workflow/
    └── SKILL.md          # Git/GitHub operations
```

#### 2. Project Skills (`.claude/skills/`)

Skills specific to **this project only**:

```
.claude/
├── settings.json                    # Permissions & hooks
├── hooks/
│   └── session-startup.sh          # Runs on Claude Code start
└── skills/
    └── project-conventions/
        └── SKILL.md                 # Project-specific standards
```

### Configuration Files

#### `CLAUDE.md`

The project's **source of truth** for conventions:
- Code style and formatting
- Git/GitHub workflows
- Testing requirements
- Security guidelines
- Architecture decisions

**Always check this file before starting work.**

#### `.claude/settings.json`

Defines what tools Claude can use:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",      // npm commands
      "Bash(git:*)",      // git commands
      "Bash(gh:*)",       // GitHub CLI
      "Bash(expo:*)"      // Expo commands
    ]
  }
}
```

## Available Skills

### 1. git-github-workflow (Personal Skill)

**Purpose**: Standardized Git/GitHub operations

**Use When**:
- Creating commits
- Managing branches
- Opening pull requests
- Performing code reviews
- Cleaning up merged branches

**Example Usage**:

```
# In Claude Code:
Create a new feature branch for adding user profile settings
```

Claude will:
1. Check current branch
2. Pull latest main
3. Create branch: `feature/user-profile-settings`
4. Confirm action

**Common Commands**:

```
# Commit changes
Review my changes and create a commit following conventions

# Create PR
Create a pull request for my current branch

# Cleanup
Clean up all merged branches

# Review someone's PR
Review PR #123
```

### 2. project-conventions (Project Skill)

**Purpose**: Enforce project-specific standards

**Use When**:
- Writing new components
- Structuring files
- Making architectural decisions
- Reviewing code for consistency

**Example Usage**:

```
# In Claude Code:
Create a new Card component following project conventions
```

Claude will:
1. Check file structure guidelines
2. Use proper naming conventions
3. Apply correct import order
4. Follow component template

## Common Workflows

### Workflow 1: Starting a New Feature

```
User: I need to add a new feature for exporting habit data to PDF

Claude: I'll help you set up the feature following our project standards.

1. First, let's create a feature branch:
   [Creates: feature/export-pdf]

2. Based on our project structure, I'll create:
   - src/services/exportService.ts (business logic)
   - src/components/ExportButton.tsx (UI component)
   - src/utils/pdfGenerator.ts (PDF utility)

3. Would you like me to:
   - Set up the basic file structure?
   - Install necessary dependencies (e.g., react-native-pdf)?
   - Create unit tests?
```

**Your Response**: "Yes, set up the structure and create tests"

### Workflow 2: Code Review

```
User: Review the changes in my current branch

Claude: I'll review your changes for:
- Code quality
- Project conventions
- Security issues
- Test coverage
- Documentation

[Performs review and provides feedback]

Would you like me to:
1. Fix the issues automatically?
2. Create TODO comments in the code?
3. Generate a review summary for the PR?
```

### Workflow 3: Creating a Commit

```
User: Review my changes and create a commit

Claude:
I see changes in:
- src/components/HabitCard.tsx (UI improvements)
- src/hooks/useHabits.ts (performance optimization)

These changes belong to different concerns. I recommend:

Option 1: Create 2 commits (recommended)
- "style(ui): improve HabitCard layout and spacing"
- "perf(hooks): optimize useHabits with memoization"

Option 2: Create 1 commit
- "refactor: improve HabitCard UI and hooks performance"

Which would you prefer?
```

**Your Response**: "Option 1"

### Workflow 4: Documentation

```
User: Document the exportService

Claude: I'll create comprehensive JSDoc documentation:

[Shows proposed documentation]

/**
 * Export Service
 * Handles exporting habit data in various formats
 *
 * @module services/exportService
 */

Would you also like me to:
1. Update README.md with usage examples?
2. Create a separate docs/EXPORT_FEATURE.md?
3. Add inline examples?
```

## Best Practices

### DO ✅

1. **Be Specific**
   ```
   ❌ "Fix this bug"
   ✅ "The HabitCard component crashes when habit.title is null. Add null safety checks."
   ```

2. **Provide Context**
   ```
   ❌ "Add a button"
   ✅ "Add a delete button to the HabitCard component, following the existing button patterns in src/components/Button.tsx"
   ```

3. **Review Generated Code**
   - Always read the code Claude generates
   - Test thoroughly before committing
   - Understand the logic, don't just copy-paste

4. **Iterate**
   ```
   User: Create a login form
   Claude: [Creates form]
   User: Add email validation and password strength meter
   Claude: [Enhances form]
   User: Perfect, now add loading states
   ```

5. **Use Skills Explicitly** (Optional)
   ```
   User: Using the git-github-workflow skill, create a commit for my changes
   ```

### DON'T ❌

1. **Don't Skip Review**
   - Never merge code without reading it
   - Always run tests
   - Verify functionality manually

2. **Don't Commit Blindly**
   - Review diff before confirming commits
   - Ensure commit messages are accurate
   - Check for sensitive data (API keys, etc.)

3. **Don't Override Project Standards**
   - Follow `CLAUDE.md` conventions
   - Don't ask Claude to violate security guidelines
   - Respect code review feedback

4. **Don't Depend on Claude for Everything**
   - Understand the architecture
   - Learn the patterns
   - Make informed decisions

## Troubleshooting

### Skills Not Loading

**Symptoms**: Claude doesn't follow project conventions

**Solution**:
```bash
# Restart Claude Code
# Then verify:
What Skills are available?
```

If skills aren't listed:
1. Check `.claude/skills/` directory exists
2. Verify `SKILL.md` files have correct YAML frontmatter
3. Review Claude Code logs

### Permission Errors

**Symptoms**: "Tool not allowed" or "Permission denied"

**Solution**:
1. Check `.claude/settings.json`
2. Add required tool to `permissions.allow`
3. Restart Claude Code

**Example**:
```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(your-tool:*)"  // Add your tool
    ]
  }
}
```

### Commits Don't Follow Convention

**Symptoms**: Commit messages don't use Conventional Commits

**Solution**:
```
User: My last commit message should follow Conventional Commits format

Claude: I'll help you amend it.
Current: "added new feature"
Suggested: "feat(module): add new feature description"

Would you like me to amend the commit?
```

### Claude Doesn't Follow CLAUDE.md

**Symptoms**: Generated code violates project standards

**Solution**:
```
User: Please review CLAUDE.md and regenerate following our project standards
```

## Advanced Usage

### Custom Workflows

You can create custom workflows by combining Skills:

```
User: I want to create a new feature workflow:
1. Create feature branch
2. Generate component boilerplate
3. Create test file
4. Open in VS Code

Claude: I've created a combined workflow. Here's what I'll do:
[Lists steps]

Would you like me to proceed?
```

### Batch Operations

```
User: For each file in src/components/, add PropTypes validation

Claude: I found 23 components. I'll:
1. Analyze each component's props
2. Generate PropTypes definitions
3. Add imports
4. Update files

This will modify 23 files. Proceed?
```

## Tips for Maximum Productivity

### 1. Start Sessions with Context

```
User: I'm working on the user authentication feature today.
We're implementing OAuth2 with Google and Apple login.
Current branch: feature/oauth-integration

Claude: Got it! I'm ready to help with OAuth2 integration.
What would you like to work on first?
```

### 2. Ask for Multiple Options

```
User: How should I structure the OAuth service?

Claude: Here are 3 architectural approaches:
[Describes options with pros/cons]

Which approach fits best with our current architecture?
```

### 3. Use Claude for Learning

```
User: Explain why we use useMemo in src/hooks/useHabits.ts

Claude: [Detailed explanation with examples]

Would you like me to add inline comments explaining this pattern?
```

### 4. Automate Repetitive Tasks

```
User: Create a script to generate a new feature module with:
- Component file
- Test file
- Style file
- Index export

Claude: [Creates generator script]
Usage: npm run generate:feature <name>
```

## Resources

### Documentation

- [Claude Code Official Docs](https://code.anthropic.com/docs)
- [Project CLAUDE.md](../CLAUDE.md)
- [Git Workflow Guide](https://www.conventionalcommits.org/)

### Project-Specific

- [Architecture Overview](./ARCHITECTURE.md)
- [API Documentation](./API.md)
- [Testing Guide](./TESTING.md)

### Team

- Slack: #claude-code
- Wiki: [Internal Wiki Link]
- Issues: [GitHub Issues](https://github.com/your-org/habit-tracker/issues)

## Quick Reference Card

### Common Commands

| What You Want | Say This |
|---------------|----------|
| Create commit | "Review my changes and create a commit" |
| New feature branch | "Create a feature branch for [description]" |
| Create PR | "Create a pull request for my current branch" |
| Code review | "Review the changes in my branch" |
| Cleanup | "Clean up all merged branches" |
| Fix formatting | "Format all files in src/" |
| Add tests | "Create tests for src/services/authService.ts" |
| Debug | "Help me debug why [component] is crashing" |
| Document | "Add JSDoc comments to this file" |

### Skill Reference

- `git-github-workflow`: Git operations, commits, PRs
- `project-conventions`: Project-specific standards

### Key Files

- `CLAUDE.md`: Project standards (READ THIS FIRST)
- `.claude/settings.json`: Tool permissions
- `.claude/skills/`: Project-specific skills

## Getting Help

### Within Claude Code

```
Help me understand how to use [skill name]

What are the project's Git conventions?

Show me examples of [pattern/component]
```

### Team Support

1. **Slack**: Ask in #claude-code
2. **Documentation**: Check this guide and CLAUDE.md
3. **Issues**: Create a GitHub issue with `claude-code` label
4. **Pairing**: Schedule a pairing session with a team member

---

## Welcome to the Team! 🎉

You're now set up for AI-driven development with Claude Code. Remember:

1. ✅ Review `CLAUDE.md` for project standards
2. ✅ Always review generated code
3. ✅ Test thoroughly
4. ✅ Ask questions when unsure
5. ✅ Share learnings with the team

Happy coding! 🚀

---

**Last Updated**: 2025-12-30
**Maintained By**: Development Team
**Questions?**: #claude-code on Slack
