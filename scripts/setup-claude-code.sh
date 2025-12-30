#!/bin/bash
#
# Claude Code Project Setup Script
# Automatically configures a project for AI-driven development with Claude Code
#
# Usage: bash scripts/setup-claude-code.sh
#

set -e  # Exit on error

# Colors for output
RED='\033[0:31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Determine project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Claude Code Project Setup${NC}"
echo -e "${BLUE}  AI-Driven Development Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Project: ${GREEN}$(basename "$PROJECT_ROOT")${NC}"
echo -e "Path: ${PROJECT_ROOT}"
echo ""

# Function to create file if it doesn't exist
create_if_missing() {
  local file_path="$1"
  local content="$2"

  if [ -f "$file_path" ]; then
    echo -e "${YELLOW}⚠️  File exists: $(basename "$file_path") - Skipping${NC}"
    return 1
  else
    echo "$content" > "$file_path"
    echo -e "${GREEN}✓${NC} Created: $(basename "$file_path")"
    return 0
  fi
}

# Step 1: Create directory structure
echo -e "${BLUE}[1/7]${NC} Creating directory structure..."
mkdir -p "$PROJECT_ROOT/.claude"/{skills,hooks,agents,scripts}
echo -e "${GREEN}✓${NC} Directories created"
echo ""

# Step 2: Create CLAUDE.md
echo -e "${BLUE}[2/7]${NC} Creating CLAUDE.md..."
create_if_missing "$PROJECT_ROOT/CLAUDE.md" "$(cat <<'EOF'
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

```
src/
├── components/     # Reusable UI components
├── screens/        # Screen components
├── hooks/          # Custom React hooks
├── services/       # Business logic and API calls
├── utils/          # Utility functions
├── types/          # TypeScript type definitions
└── lib/            # External library configurations
```

### Naming Conventions

- **Files**: `camelCase.ts` or `PascalCase.tsx` (for React components)
- **Components**: `PascalCase`
- **Functions**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Types/Interfaces**: `PascalCase`
- **Private functions**: Prefix with `_`

## Git/GitHub Workflow

### Commit Standards

Follow **Conventional Commits** specification:

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Scopes (examples):**
- `auth`: Authentication
- `ui`: User interface
- `api`: API integration
- `db`: Database/Firestore
- `notification`: Push notifications
- `cheer`: Cheer/reaction features

**Examples:**

```bash
feat(auth): implement OAuth2 login
fix(ui): resolve card animation glitch
docs(readme): update installation steps
chore(deps): upgrade React Native to 0.72
```

### Branch Naming

Format: `<type>/<short-description>`

```bash
feature/add-user-profile
fix/login-validation
docs/api-documentation
chore/upgrade-dependencies
```

### Pull Request Requirements

- **Title**: Follow commit message convention
- **Description**: Use PR template
- **Review**: Minimum 1 approval (for team projects)
- **Tests**: All tests must pass
- **No conflicts**: Must be up to date with main branch

## Testing

### Test Structure

```
__tests__/
├── unit/           # Unit tests
├── integration/    # Integration tests
└── e2e/            # End-to-end tests (if applicable)
```

### Test Commands

```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage

# Run specific test file
npm test path/to/test.test.ts
```

### Coverage Requirements

- **Minimum coverage**: 70%
- **Target coverage**: 85%
- **Critical paths**: 95%+

## Firebase/Firestore

### Security

- **Never commit**: `google-services.json`, `.env` files, API keys
- **Always use**: Environment variables for sensitive data
- **Firestore rules**: Must be tested before deployment

### Naming Conventions

- **Collections**: `snake_case` (e.g., `user_profiles`, `habit_cards`)
- **Documents**: Use UUIDs or meaningful IDs
- **Fields**: `snake_case` (e.g., `created_at`, `user_id`)

## Code Review Guidelines

### What to Check

- [ ] Code follows project conventions
- [ ] No sensitive data exposed
- [ ] Tests are included and passing
- [ ] Documentation updated (if needed)
- [ ] No console.log or debug code
- [ ] Error handling is appropriate
- [ ] Performance considerations addressed
- [ ] Accessibility considerations (for UI)

### Review Process

1. Automated checks must pass (linting, tests, build)
2. Manual code review by peer
3. Testing on development environment
4. Approval and merge

## Dependencies Management

### Adding Dependencies

```bash
# Production dependency
npm install <package-name>

# Development dependency
npm install --save-dev <package-name>
```

### Before Adding a New Dependency

- [ ] Check if similar functionality exists
- [ ] Review package quality (stars, downloads, maintenance)
- [ ] Check bundle size impact
- [ ] Review security vulnerabilities
- [ ] Consider alternatives

### Regular Maintenance

```bash
# Check for outdated packages
npm outdated

# Security audit
npm audit

# Fix security issues
npm audit fix
```

## Performance Guidelines

### React Native Best Practices

- Use `React.memo()` for expensive components
- Implement `useMemo()` and `useCallback()` appropriately
- Avoid inline functions in render
- Optimize FlatList with `getItemLayout`, `keyExtractor`
- Use `InteractionManager` for heavy operations
- Profile with React DevTools

### Bundle Size

- Monitor app size regularly
- Use code splitting where possible
- Lazy load heavy components
- Optimize images and assets

## Security Guidelines

### Sensitive Data

- **Never commit**:
  - API keys
  - Firebase configuration files (`google-services.json`)
  - `.env` files
  - Private keys
  - User passwords or tokens

### Code Security

- Validate all user input
- Sanitize data before database operations
- Use parameterized queries (Firestore)
- Implement proper authentication checks
- Follow OWASP Mobile Top 10

## Deployment

### Pre-Deployment Checklist

- [ ] All tests passing
- [ ] No console warnings or errors
- [ ] Security audit clean (`npm audit`)
- [ ] Environment variables configured
- [ ] Firebase rules updated
- [ ] Documentation up to date
- [ ] Version number bumped (semantic versioning)

### Version Numbering

Follow **Semantic Versioning** (semver):

- `MAJOR.MINOR.PATCH`
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

## AI-Driven Development with Claude

### When to Use Claude Code

- Writing boilerplate code
- Refactoring complex logic
- Writing tests
- Documentation generation
- Code reviews
- Debugging assistance
- Architecture decisions

### How to Work with Claude

1. **Be specific**: Provide clear context and requirements
2. **Review output**: Always review generated code
3. **Test thoroughly**: Never merge without testing
4. **Iterate**: Provide feedback for improvements
5. **Learn patterns**: Understand the code, don't just copy

### Claude Code Skills Available

This project includes the following Skills:

- `git-github-workflow`: Git/GitHub operations
- `project-conventions`: Project-specific standards (this file)

See `.claude/skills/` directory for details.

## Troubleshooting

### Common Issues

**Issue**: Metro bundler won't start
```bash
# Solution
npx react-native start --reset-cache
```

**Issue**: Build fails after dependency update
```bash
# Solution
rm -rf node_modules
npm install
cd ios && pod install && cd ..  # For iOS
```

**Issue**: Firebase connection issues
```bash
# Check .env configuration
# Verify google-services.json is present
# Check Firebase console for project status
```

## Resources

### Documentation

- [React Native Docs](https://reactnative.dev/)
- [Expo Docs](https://docs.expo.dev/)
- [Firebase Docs](https://firebase.google.com/docs)
- [TypeScript Docs](https://www.typescriptlang.org/docs/)

### Project-Specific

- [API Documentation](docs/API.md)
- [Architecture Overview](docs/ARCHITECTURE.md)
- [Contributing Guide](.github/CONTRIBUTING.md)

## Contact

For questions or issues:

- Create an issue on GitHub
- Contact the maintainer
- Join the team Slack channel (if applicable)

---

**Last Updated**: 2025-12-30
**Maintained By**: Development Team
EOF
)" && echo "" || echo ""

# Step 3: Create .claude/settings.json
echo -e "${BLUE}[3/7]${NC} Creating .claude/settings.json..."
create_if_missing "$PROJECT_ROOT/.claude/settings.json" "$(cat <<'EOF'
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(npx:*)",
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(expo:*)"
    ]
  },
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/session-startup.sh"
          }
        ]
      }
    ]
  }
}
EOF
)" && echo "" || echo ""

# Step 4: Create session startup hook
echo -e "${BLUE}[4/7]${NC} Creating session startup hook..."
create_if_missing "$PROJECT_ROOT/.claude/hooks/session-startup.sh" "$(cat <<'EOF'
#!/bin/bash
#
# Claude Code Session Startup Hook
# Runs when a new Claude Code session starts
#

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Claude Code Session Started"
echo "  Project: $(basename $CLAUDE_PROJECT_DIR)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Available Skills:"
echo "  - git-github-workflow: Git/GitHub operations"
echo "  - project-conventions: Project standards"
echo ""
echo "💡 Quick Commands:"
echo "  - 'What Skills are available?' - List all skills"
echo "  - Review CLAUDE.md for project standards"
echo ""
echo "🔍 Project Status:"

# Check git status
if [ -d "$CLAUDE_PROJECT_DIR/.git" ]; then
  BRANCH=$(cd "$CLAUDE_PROJECT_DIR" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
  echo "  Git branch: $BRANCH"
fi

# Check if dependencies are installed
if [ ! -d "$CLAUDE_PROJECT_DIR/node_modules" ]; then
  echo "  ⚠️  Dependencies not installed. Run: npm install"
fi

echo ""
exit 0
EOF
)" && chmod +x "$PROJECT_ROOT/.claude/hooks/session-startup.sh" && echo "" || echo ""

# Step 5: Create project-specific skill
echo -e "${BLUE}[5/7]${NC} Creating project-specific skill..."
mkdir -p "$PROJECT_ROOT/.claude/skills/project-conventions"
create_if_missing "$PROJECT_ROOT/.claude/skills/project-conventions/SKILL.md" "$(cat <<'EOF'
---
name: project-conventions
description: Enforces project-specific conventions for this codebase. Use when writing code, creating files, or making architectural decisions specific to this project.
allowed-tools: Read, Glob, Grep
---

# Project-Specific Conventions

## Quick Reference

This Skill enforces conventions specific to this project. Always check `CLAUDE.md` for the most up-to-date standards.

### File Structure

- Components: `src/components/`
- Screens: `src/screens/` or `app/`
- Hooks: `src/hooks/`
- Services: `src/services/`
- Utils: `src/utils/`
- Types: `src/types/`

### Import Order

```typescript
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
```

### Component Template

```typescript
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

interface ComponentNameProps {
  // Props definition
}

export const ComponentName: React.FC<ComponentNameProps> = ({ }) => {
  // Component logic

  return (
    <View style={styles.container}>
      {/* JSX */}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    // Styles
  },
});
```

## See Also

- Full standards: `CLAUDE.md`
- Architecture: `docs/ARCHITECTURE.md`
EOF
)" && echo "" || echo ""

# Step 6: Update .gitignore
echo -e "${BLUE}[6/7]${NC} Updating .gitignore..."
if [ -f "$PROJECT_ROOT/.gitignore" ]; then
  if ! grep -q ".claude/settings.local.json" "$PROJECT_ROOT/.gitignore"; then
    echo "" >> "$PROJECT_ROOT/.gitignore"
    echo "# Claude Code" >> "$PROJECT_ROOT/.gitignore"
    echo ".claude/settings.local.json" >> "$PROJECT_ROOT/.gitignore"
    echo -e "${GREEN}✓${NC} Updated .gitignore"
  else
    echo -e "${YELLOW}⚠️  .gitignore already configured${NC}"
  fi
else
  create_if_missing "$PROJECT_ROOT/.gitignore" "$(cat <<'EOF'
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
EOF
)"
fi
echo ""

# Step 7: Create README section
echo -e "${BLUE}[7/7]${NC} Setup complete!"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ Claude Code Setup Successful${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📁 Created Files:${NC}"
echo "  ✓ CLAUDE.md"
echo "  ✓ .claude/settings.json"
echo "  ✓ .claude/hooks/session-startup.sh"
echo "  ✓ .claude/skills/project-conventions/SKILL.md"
echo "  ✓ .gitignore (updated)"
echo ""
echo -e "${BLUE}📚 Personal Skills (all projects):${NC}"
echo "  ✓ ~/.claude/skills/git-github-workflow/"
echo ""
echo -e "${BLUE}🎯 Next Steps:${NC}"
echo ""
echo "  1. Review and customize:"
echo "     ${YELLOW}$PROJECT_ROOT/CLAUDE.md${NC}"
echo ""
echo "  2. Commit these changes:"
echo "     ${YELLOW}git add .claude/ CLAUDE.md scripts/${NC}"
echo "     ${YELLOW}git commit -m \"chore: setup Claude Code configuration\"${NC}"
echo ""
echo "  3. Restart Claude Code to load new configuration"
echo ""
echo "  4. Test the setup:"
echo "     ${YELLOW}What Skills are available?${NC}"
echo ""
echo -e "${BLUE}💡 Tips:${NC}"
echo "  - Review CLAUDE.md for project standards"
echo "  - Use Personal Skills across all projects"
echo "  - Customize project-specific conventions in .claude/skills/"
echo ""
echo -e "${GREEN}Happy AI-driven development! 🚀${NC}"
echo ""

exit 0
