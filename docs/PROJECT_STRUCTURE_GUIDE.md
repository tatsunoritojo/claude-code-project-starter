# Project Structure Guide

This guide explains the recommended project structure when using this Claude Code template.

## Basic Structure

```
your-project/
├── .claude/                    # Claude Code configuration
│   ├── settings.json          # Tool permissions & hooks
│   ├── hooks/                 # Lifecycle hooks
│   │   └── session-startup.sh
│   ├── skills/                # Project-specific skills
│   │   └── project-conventions/
│   └── agents/                # Custom agents (optional)
│
├── docs/                      # Documentation
│   ├── ARCHITECTURE.md        # System architecture
│   ├── API.md                 # API documentation
│   └── CLAUDE_CODE_ONBOARDING.md
│
├── scripts/                   # Automation scripts
│   ├── setup-claude-code.sh
│   └── setup-claude-code.ps1
│
├── src/                       # Source code
│   ├── components/            # Reusable components
│   ├── services/              # Business logic
│   ├── utils/                 # Utility functions
│   └── types/                 # Type definitions
│
├── tests/                     # Test files
│   ├── unit/
│   ├── integration/
│   └── e2e/
│
├── .gitignore                 # Git ignore patterns
├── CLAUDE.md                  # Project standards
├── README.md                  # Project README
├── package.json               # Dependencies (Node.js)
└── LICENSE                    # License file
```

## Directory Purposes

### `.claude/`

**Purpose**: Claude Code configuration

- `settings.json`: Tool permissions and hook configurations
- `hooks/`: Scripts that run at specific lifecycle events
- `skills/`: Project-specific AI skills
- `agents/`: Custom AI agents (advanced)

**Don't commit**: `.claude/settings.local.json` (personal settings)

### `docs/`

**Purpose**: Project documentation

Recommended files:
- `ARCHITECTURE.md`: System design and architecture
- `API.md`: API endpoints and usage
- `CONTRIBUTING.md`: Contribution guidelines
- `CLAUDE_CODE_ONBOARDING.md`: Team onboarding
- `DEPLOYMENT.md`: Deployment procedures

### `scripts/`

**Purpose**: Automation and utility scripts

Common scripts:
- `setup-claude-code.sh`: Initialize Claude Code
- `deploy.sh`: Deployment automation
- `test.sh`: Test runner
- `build.sh`: Build automation

### `src/`

**Purpose**: Application source code

Structure depends on your tech stack:

#### React/React Native
```
src/
├── components/        # UI components
├── screens/          # Screen components
├── hooks/            # Custom React hooks
├── services/         # API calls, business logic
├── utils/            # Helper functions
├── types/            # TypeScript types
├── constants/        # Constants and configs
└── lib/              # Third-party integrations
```

#### Node.js/Express
```
src/
├── controllers/      # Request handlers
├── models/           # Data models
├── routes/           # API routes
├── middleware/       # Express middleware
├── services/         # Business logic
├── utils/            # Helper functions
└── types/            # TypeScript types
```

#### Python/Django
```
src/
├── apps/             # Django apps
├── models/           # Data models
├── views/            # View logic
├── serializers/      # API serializers
├── services/         # Business logic
└── utils/            # Helper functions
```

### `tests/`

**Purpose**: Automated tests

```
tests/
├── unit/             # Unit tests
│   ├── components/
│   ├── services/
│   └── utils/
├── integration/      # Integration tests
│   └── api/
└── e2e/             # End-to-end tests
    └── scenarios/
```

## File Naming Conventions

### General Rules

- **Descriptive names**: Use clear, meaningful names
- **Consistency**: Follow project conventions in CLAUDE.md
- **Case**: Follow language conventions (camelCase, snake_case, etc.)

### Common Patterns

#### React/TypeScript
```
PascalCase.tsx        # React components
camelCase.ts          # Utilities, services
camelCase.test.ts     # Test files
camelCase.types.ts    # Type definitions
```

#### Node.js
```
camelCase.js          # General files
camelCase.service.js  # Services
camelCase.controller.js # Controllers
camelCase.test.js     # Tests
```

#### Python
```
snake_case.py         # General files
test_snake_case.py    # Test files
```

## Configuration Files

### Root Level
```
your-project/
├── .gitignore        # Git ignore patterns
├── .env.example      # Environment variable template
├── package.json      # Node.js dependencies
├── tsconfig.json     # TypeScript config
├── jest.config.js    # Jest config
├── .prettierrc       # Prettier config
├── .eslintrc.js      # ESLint config
└── CLAUDE.md         # Project standards
```

### Claude Code
```
.claude/
├── settings.json     # Global settings
├── settings.local.json # Personal settings (git-ignored)
└── hooks/
    └── *.sh          # Hook scripts
```

## Example: React Native Project

```
habit-tracker/
├── .claude/
│   ├── settings.json
│   ├── hooks/
│   │   └── session-startup.sh
│   └── skills/
│       └── project-conventions/
│
├── app/                        # Expo Router screens
│   ├── (tabs)/
│   │   ├── home.tsx
│   │   ├── notifications.tsx
│   │   └── settings.tsx
│   ├── _layout.tsx
│   └── index.tsx
│
├── src/
│   ├── components/            # Reusable components
│   │   ├── Calendar.tsx
│   │   ├── Card.tsx
│   │   └── Button.tsx
│   ├── hooks/                 # Custom hooks
│   │   ├── useAuth.ts
│   │   ├── useCards.ts
│   │   └── useSettings.ts
│   ├── services/              # Business logic
│   │   ├── authService.ts
│   │   ├── cardService.ts
│   │   └── logService.ts
│   ├── utils/                 # Utilities
│   │   ├── dateUtils.ts
│   │   ├── validation.ts
│   │   └── gamification.ts
│   ├── types/                 # Type definitions
│   │   └── index.ts
│   └── lib/                   # Integrations
│       └── firebase.ts
│
├── assets/                    # Static assets
│   ├── images/
│   ├── fonts/
│   └── animations/
│
├── __tests__/                 # Tests
│   ├── unit/
│   ├── integration/
│   └── e2e/
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── API.md
│   └── CLAUDE_CODE_ONBOARDING.md
│
├── scripts/
│   ├── setup-claude-code.sh
│   └── seedTemplates.ts
│
├── .gitignore
├── CLAUDE.md
├── README.md
├── package.json
├── tsconfig.json
├── app.json                   # Expo config
└── babel.config.js
```

## Best Practices

### 1. Separation of Concerns

```
✅ Good
src/
├── components/        # UI only
├── services/          # Business logic
└── utils/             # Pure functions

❌ Bad
src/
└── stuff/             # Everything mixed
```

### 2. Consistent Naming

```
✅ Good
useAuth.ts             # Hook
authService.ts         # Service
Auth.test.ts           # Test

❌ Bad
auth_hook.ts
AuthServices.ts
testAuth.ts
```

### 3. Clear Module Boundaries

```
✅ Good
src/
├── user/
│   ├── UserProfile.tsx
│   ├── userService.ts
│   └── userTypes.ts
└── auth/
    ├── Login.tsx
    ├── authService.ts
    └── authTypes.ts

❌ Bad
src/
├── UserProfile.tsx
├── Login.tsx
├── services.ts        # All services mixed
└── types.ts           # All types mixed
```

### 4. Documentation Proximity

Keep related documentation close to code:

```
src/
└── services/
    ├── paymentService.ts
    ├── paymentService.test.ts
    └── README.md          # Service-specific docs
```

## Scaling Guidelines

### Small Projects (<10 files)

```
src/
├── components/
├── utils/
└── types/
```

### Medium Projects (10-50 files)

```
src/
├── components/
├── hooks/
├── services/
├── utils/
└── types/
```

### Large Projects (50+ files)

```
src/
├── features/          # Feature-based modules
│   ├── auth/
│   ├── dashboard/
│   └── settings/
├── shared/            # Shared utilities
│   ├── components/
│   ├── hooks/
│   └── utils/
└── core/              # Core functionality
    ├── api/
    ├── config/
    └── types/
```

## Migration Path

### From No Structure

1. Create basic directories
2. Move files to appropriate locations
3. Update imports
4. Test thoroughly

### From Different Structure

1. Map old structure to new
2. Create migration script
3. Update all imports
4. Verify functionality

## Tools & Automation

### File Generators

Use Claude Code to generate files:

```
# In Claude Code:
Create a new component called UserProfile following our project structure

# Claude will:
# 1. Create src/components/UserProfile.tsx
# 2. Create src/components/UserProfile.test.tsx
# 3. Follow naming conventions from CLAUDE.md
```

### Import Management

```
# In Claude Code:
Organize imports in all files following our convention

# Claude will:
# 1. Group imports (external, internal, relative)
# 2. Sort alphabetically
# 3. Remove unused imports
```

## Conclusion

A well-organized project structure:

- ✅ Makes code easier to find
- ✅ Improves team collaboration
- ✅ Enables better tooling
- ✅ Scales with project growth
- ✅ Reduces cognitive load

Follow these guidelines and customize based on your project's needs.

---

**Need help?** Ask Claude Code: "Explain our project structure" or "Where should I put this file?"
