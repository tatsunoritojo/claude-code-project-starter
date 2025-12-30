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
