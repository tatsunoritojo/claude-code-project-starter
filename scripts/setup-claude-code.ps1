#
# Claude Code Project Setup Script (PowerShell)
# Automatically configures a project for AI-driven development with Claude Code
#
# Usage: .\scripts\setup-claude-code.ps1
#

$ErrorActionPreference = "Stop"

# Determine project root
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$ProjectName = Split-Path -Leaf $ProjectRoot

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host "  Claude Code Project Setup" -ForegroundColor Blue
Write-Host "  AI-Driven Development Configuration" -ForegroundColor Blue
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
Write-Host ""
Write-Host "Project: " -NoNewline
Write-Host $ProjectName -ForegroundColor Green
Write-Host "Path: $ProjectRoot"
Write-Host ""

# Function to create file if it doesn't exist
function New-FileIfMissing {
    param (
        [string]$Path,
        [string]$Content
    )

    if (Test-Path $Path) {
        Write-Host "⚠️  File exists: $(Split-Path -Leaf $Path) - Skipping" -ForegroundColor Yellow
        return $false
    }
    else {
        Set-Content -Path $Path -Value $Content -Encoding UTF8
        Write-Host "✓ Created: $(Split-Path -Leaf $Path)" -ForegroundColor Green
        return $true
    }
}

# Step 1: Create directory structure
Write-Host "[1/7] Creating directory structure..." -ForegroundColor Blue
$null = New-Item -ItemType Directory -Force -Path "$ProjectRoot\.claude\skills"
$null = New-Item -ItemType Directory -Force -Path "$ProjectRoot\.claude\hooks"
$null = New-Item -ItemType Directory -Force -Path "$ProjectRoot\.claude\agents"
$null = New-Item -ItemType Directory -Force -Path "$ProjectRoot\.claude\scripts"
Write-Host "✓ Directories created" -ForegroundColor Green
Write-Host ""

# Step 2: Create CLAUDE.md
Write-Host "[2/7] Creating CLAUDE.md..." -ForegroundColor Blue
$claudeMdContent = @"
# Claude Code Project Configuration

## Overview

This project uses **Claude Code** for AI-driven development. This document defines project standards, conventions, and guidelines that Claude should follow.

## Project Information

- **Name**: Habit Tracker
- **Type**: React Native Mobile Application (Expo)
- **Language**: TypeScript
- **Package Manager**: npm
- **Framework**: React Native with Expo

## Development Standards

### Code Style

- **Formatter**: Prettier
- **Linter**: ESLint with TypeScript support
- **Style Guide**: Airbnb TypeScript Style Guide
- **Indentation**: 2 spaces
- **Quotes**: Single quotes for strings
- **Semicolons**: Required

### File Organization

``````
src/
├── components/     # Reusable UI components
├── screens/        # Screen components
├── hooks/          # Custom React hooks
├── services/       # Business logic and API calls
├── utils/          # Utility functions
├── types/          # TypeScript type definitions
└── lib/            # External library configurations
``````

### Naming Conventions

- **Files**: ``camelCase.ts`` or ``PascalCase.tsx`` (for React components)
- **Components**: ``PascalCase``
- **Functions**: ``camelCase``
- **Constants**: ``UPPER_SNAKE_CASE``
- **Types/Interfaces**: ``PascalCase``
- **Private functions**: Prefix with ``_``

## Git/GitHub Workflow

### Commit Standards

Follow **Conventional Commits** specification:

``````
<type>(<scope>): <subject>

[optional body]

[optional footer]
``````

**Types:**
- ``feat``: New feature
- ``fix``: Bug fix
- ``docs``: Documentation changes
- ``style``: Code style changes (formatting, etc.)
- ``refactor``: Code refactoring
- ``perf``: Performance improvements
- ``test``: Adding or updating tests
- ``chore``: Maintenance tasks

**Examples:**

``````bash
feat(auth): implement OAuth2 login
fix(ui): resolve card animation glitch
docs(readme): update installation steps
chore(deps): upgrade React Native to 0.72
``````

### Branch Naming

Format: ``<type>/<short-description>``

``````bash
feature/add-user-profile
fix/login-validation
docs/api-documentation
chore/upgrade-dependencies
``````

## Testing

### Test Commands

``````bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage
``````

### Coverage Requirements

- **Minimum coverage**: 70%
- **Target coverage**: 85%
- **Critical paths**: 95%+

## Firebase/Firestore

### Security

- **Never commit**: ``google-services.json``, ``.env`` files, API keys
- **Always use**: Environment variables for sensitive data

### Naming Conventions

- **Collections**: ``snake_case`` (e.g., ``user_profiles``, ``habit_cards``)
- **Documents**: Use UUIDs or meaningful IDs
- **Fields**: ``snake_case`` (e.g., ``created_at``, ``user_id``)

## Code Review Guidelines

### What to Check

- [ ] Code follows project conventions
- [ ] No sensitive data exposed
- [ ] Tests are included and passing
- [ ] Documentation updated (if needed)
- [ ] No console.log or debug code
- [ ] Error handling is appropriate

## Security Guidelines

### Sensitive Data

- **Never commit**:
  - API keys
  - Firebase configuration files
  - ``.env`` files
  - Private keys

### Code Security

- Validate all user input
- Sanitize data before database operations
- Implement proper authentication checks

## AI-Driven Development with Claude

### Claude Code Skills Available

- ``git-github-workflow``: Git/GitHub operations
- ``project-conventions``: Project-specific standards

See ``.claude/skills/`` directory for details.

---

**Last Updated**: 2025-12-30
**Maintained By**: Development Team
"@

New-FileIfMissing -Path "$ProjectRoot\CLAUDE.md" -Content $claudeMdContent
Write-Host ""

# Step 3: Create settings.json
Write-Host "[3/7] Creating .claude/settings.json..." -ForegroundColor Blue
$settingsJson = @"
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(npx:*)",
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(expo:*)"
    ]
  }
}
"@

New-FileIfMissing -Path "$ProjectRoot\.claude\settings.json" -Content $settingsJson
Write-Host ""

# Step 4: Create project-specific skill
Write-Host "[4/7] Creating project-specific skill..." -ForegroundColor Blue
$null = New-Item -ItemType Directory -Force -Path "$ProjectRoot\.claude\skills\project-conventions"
$skillMd = @"
---
name: project-conventions
description: Enforces project-specific conventions for this codebase. Use when writing code, creating files, or making architectural decisions specific to this project.
allowed-tools: Read, Glob, Grep
---

# Project-Specific Conventions

## Quick Reference

This Skill enforces conventions specific to this project. Always check ``CLAUDE.md`` for the most up-to-date standards.

### File Structure

- Components: ``src/components/``
- Screens: ``src/screens/`` or ``app/``
- Hooks: ``src/hooks/``
- Services: ``src/services/``
- Utils: ``src/utils/``
- Types: ``src/types/``

### Import Order

``````typescript
// 1. External imports
import React from 'react';
import { View, Text } from 'react-native';

// 2. Internal absolute imports
import { Button } from '@/components';
import { useAuth } from '@/hooks';

// 3. Relative imports
import { localHelper } from './helpers';

// 4. Types
import type { User } from '@/types';
``````

## See Also

- Full standards: ``CLAUDE.md``
- Architecture: ``docs/ARCHITECTURE.md``
"@

New-FileIfMissing -Path "$ProjectRoot\.claude\skills\project-conventions\SKILL.md" -Content $skillMd
Write-Host ""

# Step 5: Update .gitignore
Write-Host "[5/7] Updating .gitignore..." -ForegroundColor Blue
if (Test-Path "$ProjectRoot\.gitignore") {
    $gitignoreContent = Get-Content "$ProjectRoot\.gitignore" -Raw
    if ($gitignoreContent -notmatch ".claude/settings.local.json") {
        Add-Content -Path "$ProjectRoot\.gitignore" -Value "`n# Claude Code`n.claude/settings.local.json"
        Write-Host "✓ Updated .gitignore" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  .gitignore already configured" -ForegroundColor Yellow
    }
}
else {
    $gitignoreContent = @"
# Dependencies
node_modules/

# Environment variables
.env
.env.local
.env.*.local

# Claude Code
.claude/settings.local.json

# Build outputs
dist/
build/
*.log

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
"@
    New-FileIfMissing -Path "$ProjectRoot\.gitignore" -Content $gitignoreContent
}
Write-Host ""

# Step 6: Setup complete
Write-Host "[6/7] Checking Personal Skills..." -ForegroundColor Blue
$personalSkillsPath = "$env:USERPROFILE\.claude\skills\git-github-workflow"
if (Test-Path "$personalSkillsPath\SKILL.md") {
    Write-Host "✓ Personal Skills already configured" -ForegroundColor Green
}
else {
    Write-Host "⚠️  Personal Skills not found. Run the Bash setup script or create manually." -ForegroundColor Yellow
}
Write-Host ""

# Step 7: Summary
Write-Host "[7/7] Setup complete!" -ForegroundColor Blue
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  ✓ Claude Code Setup Successful" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Created Files:" -ForegroundColor Blue
Write-Host "  ✓ CLAUDE.md"
Write-Host "  ✓ .claude/settings.json"
Write-Host "  ✓ .claude/skills/project-conventions/SKILL.md"
Write-Host "  ✓ .gitignore (updated)"
Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Blue
Write-Host ""
Write-Host "  1. Review and customize:"
Write-Host "     " -NoNewline
Write-Host "$ProjectRoot\CLAUDE.md" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. Commit these changes:"
Write-Host "     " -NoNewline
Write-Host "git add .claude/ CLAUDE.md scripts/" -ForegroundColor Yellow
Write-Host "     " -NoNewline
Write-Host "git commit -m `"chore: setup Claude Code configuration`"" -ForegroundColor Yellow
Write-Host ""
Write-Host "  3. Restart Claude Code to load new configuration"
Write-Host ""
Write-Host "  4. Test the setup:"
Write-Host "     " -NoNewline
Write-Host "What Skills are available?" -ForegroundColor Yellow
Write-Host ""
Write-Host "💡 Tips:" -ForegroundColor Blue
Write-Host "  - Review CLAUDE.md for project standards"
Write-Host "  - Use Personal Skills across all projects"
Write-Host "  - Customize project-specific conventions in .claude/skills/"
Write-Host ""
Write-Host "Happy AI-driven development! 🚀" -ForegroundColor Green
Write-Host ""
