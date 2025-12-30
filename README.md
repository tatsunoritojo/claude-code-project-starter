# Claude Code Project Starter

> A complete template for AI-driven development with Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Ready-brightgreen.svg)](https://code.anthropic.com/)

**Start your next project with AI-powered development from day one.**

This template provides a complete, production-ready configuration for [Claude Code](https://code.anthropic.com/), enabling AI-driven development with best practices, automated workflows, and team collaboration built-in.

## 🌟 Features

### Intelligent Git/GitHub Workflows
- ✅ **Conventional Commits** - Automated commit message formatting
- ✅ **Smart Branching** - Intelligent branch naming and management
- ✅ **PR Automation** - One-command pull request creation
- ✅ **Code Review** - AI-assisted code reviews
- ✅ **Auto-Cleanup** - Automatic merged branch deletion

### Project Standards
- ✅ **Comprehensive Guidelines** - Complete project standards in `CLAUDE.md`
- ✅ **Code Style Enforcement** - Consistent formatting and conventions
- ✅ **Security Best Practices** - Built-in security guidelines
- ✅ **Testing Requirements** - Defined coverage and testing standards
- ✅ **Documentation Templates** - Ready-to-use documentation structure

### Team Collaboration
- ✅ **Quick Onboarding** - Detailed onboarding guide for new team members
- ✅ **Consistent Experience** - Same AI assistant across the entire team
- ✅ **Knowledge Sharing** - Documented patterns and best practices
- ✅ **Automated Setup** - One-command project initialization

### Developer Experience
- ✅ **Session Hooks** - Automatic environment checks on startup
- ✅ **Personal Skills** - Global skills available across all projects
- ✅ **Project Skills** - Project-specific conventions and standards
- ✅ **Cross-Platform** - Works on Linux, macOS, and Windows

## 🚀 Quick Start

### Prerequisites

- **Claude Code** - [Install Claude Code](https://code.anthropic.com/install)
- **Node.js** 18+ (if building Node.js projects)
- **Git** - Version control
- **GitHub CLI** (optional) - For enhanced GitHub integration

### Option 1: Use as GitHub Template

1. Click **"Use this template"** button on GitHub
2. Create your new repository
3. Clone your new repository
4. Run the setup script

```bash
# Linux/macOS
bash scripts/setup-claude-code.sh

# Windows (PowerShell)
.\scripts\setup-claude-code.ps1
```

### Option 2: Clone Directly

```bash
# Clone this template
git clone https://github.com/YOUR_USERNAME/claude-code-project-starter.git my-new-project
cd my-new-project

# Remove template's git history
rm -rf .git
git init

# Run setup
bash scripts/setup-claude-code.sh

# Start your project
git add .
git commit -m "chore: initialize project from Claude Code template"
```

### Option 3: Manual Integration

Copy files into your existing project:

```bash
# Copy Claude Code configuration
cp -r claude-code-project-starter/.claude your-project/
cp claude-code-project-starter/CLAUDE.md your-project/
cp -r claude-code-project-starter/scripts your-project/

# Run setup
cd your-project
bash scripts/setup-claude-code.sh
```

## 📁 What's Included

```
claude-code-project-starter/
├── .claude/
│   ├── settings.json                    # Tool permissions & configurations
│   ├── hooks/
│   │   └── session-startup.sh          # Runs on Claude Code start
│   └── skills/
│       └── project-conventions/
│           └── SKILL.md                 # Project-specific conventions
│
├── docs/
│   └── CLAUDE_CODE_ONBOARDING.md       # Team onboarding guide
│
├── scripts/
│   ├── setup-claude-code.sh            # Linux/macOS setup script
│   └── setup-claude-code.ps1           # Windows PowerShell setup
│
├── CLAUDE.md                            # Project standards & guidelines
├── README.md                            # This file
├── .gitignore                           # Git ignore patterns
└── LICENSE                              # MIT License
```

### Personal Skills (Global)

Additionally, this template installs **Personal Skills** in `~/.claude/skills/`:

```
~/.claude/skills/
└── git-github-workflow/
    └── SKILL.md                         # Available in ALL your projects
```

## 📚 Documentation

### Core Files

| File | Purpose |
|------|---------|
| **CLAUDE.md** | Complete project standards, conventions, and guidelines |
| **docs/CLAUDE_CODE_ONBOARDING.md** | Comprehensive team onboarding guide |
| **.claude/settings.json** | Tool permissions and hook configurations |
| **.claude/skills/** | Project-specific AI skills |
| **scripts/setup-claude-code.sh** | Automated project setup |

### Quick Links

- 📖 [Project Standards](CLAUDE.md) - All conventions and guidelines
- 🎓 [Team Onboarding](docs/CLAUDE_CODE_ONBOARDING.md) - Getting started guide
- 🔧 [Setup Scripts](scripts/) - Automated configuration
- 🎯 [Claude Code Docs](https://code.anthropic.com/docs) - Official documentation

## 🎯 Usage Examples

### Creating a Commit

```
# In Claude Code:
Review my changes and create a commit

# Claude will:
# 1. Analyze your changes
# 2. Suggest a Conventional Commit message
# 3. Create the commit with proper formatting
```

### Starting a New Feature

```
# In Claude Code:
Create a new feature branch for user authentication

# Claude will:
# 1. Ensure you're on main
# 2. Pull latest changes
# 3. Create: feature/user-authentication
# 4. Confirm the branch creation
```

### Creating a Pull Request

```
# In Claude Code:
Create a pull request for my current branch

# Claude will:
# 1. Push your branch to remote
# 2. Generate PR title and description
# 3. Create the PR using gh CLI
# 4. Return the PR URL
```

### Project Cleanup

```
# In Claude Code:
Clean up all merged branches

# Claude will:
# 1. Identify merged branches
# 2. Delete local branches
# 3. Delete remote branches
# 4. Prune remote references
```

## 🛠️ Customization

### Modifying Project Standards

Edit `CLAUDE.md` to define your project's specific:

- Code style and formatting rules
- Git/GitHub workflows
- Testing requirements
- Security guidelines
- Architecture decisions
- Naming conventions

### Adding Custom Skills

Create new skills in `.claude/skills/`:

```bash
mkdir -p .claude/skills/your-skill-name
nano .claude/skills/your-skill-name/SKILL.md
```

**SKILL.md template:**

```yaml
---
name: your-skill-name
description: What this skill does and when to use it
allowed-tools: Bash(npm:*), Read, Write
---

# Your Skill Name

## Instructions
[Step-by-step guidance]

## Examples
[Usage examples]
```

### Configuring Permissions

Edit `.claude/settings.json` to control tool access:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(git:*)",
      "Bash(your-tool:*)"
    ]
  }
}
```

### Adding Hooks

Create custom hooks in `.claude/hooks/`:

```bash
# Example: pre-commit hook
nano .claude/hooks/pre-commit.sh
chmod +x .claude/hooks/pre-commit.sh
```

## 🏗️ Project Types

This template works with any project type. Customize for your stack:

### React/React Native

```markdown
# In CLAUDE.md:
- Framework: React Native with Expo
- State Management: Redux / Zustand
- Styling: StyleSheet / Tailwind
```

### Node.js/TypeScript

```markdown
# In CLAUDE.md:
- Runtime: Node.js 18+
- Language: TypeScript 5+
- Framework: Express / NestJS
```

### Python

```markdown
# In CLAUDE.md:
- Language: Python 3.11+
- Framework: FastAPI / Django
- Package Manager: Poetry / pip
```

### Other Languages

Easily adaptable for:
- Go
- Rust
- Java/Kotlin
- C#/.NET
- PHP
- Ruby

## 👥 Team Collaboration

### For Team Leads

1. **Setup Template**
   ```bash
   # Make this repository a template on GitHub
   gh repo edit --template=true
   ```

2. **Create Team Guidelines**
   - Customize `CLAUDE.md` for your team
   - Define project-specific conventions
   - Add security policies

3. **Share with Team**
   - Have team members use the template
   - Ensure everyone runs setup scripts
   - Review onboarding documentation together

### For Team Members

1. **Clone Team's Template**
   ```bash
   # Use your team's template repository
   gh repo create my-project --template=team/project-template
   ```

2. **Run Setup**
   ```bash
   bash scripts/setup-claude-code.sh
   ```

3. **Review Standards**
   - Read `CLAUDE.md`
   - Review `docs/CLAUDE_CODE_ONBOARDING.md`
   - Ask questions in team chat

## 🔐 Security

### Sensitive Data Protection

This template automatically configures `.gitignore` to exclude:

- `.env` files
- API keys and secrets
- Local settings (`.claude/settings.local.json`)
- Credentials and tokens

### Security Best Practices

See `CLAUDE.md` for complete security guidelines including:

- Input validation
- Data sanitization
- Authentication/authorization
- Dependency management
- Secret management

## 🧪 Testing

### Running Tests

Customize test commands in `CLAUDE.md`:

```markdown
## Testing

### Test Commands

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage
```

### Coverage Requirements

- Minimum: 70%
- Target: 85%
- Critical paths: 95%+
```
```

## 📦 Deployment

### CI/CD Integration

Add GitHub Actions workflow:

```yaml
# .github/workflows/claude-code-check.yml
name: Claude Code Standards

on: [push, pull_request]

jobs:
  check-standards:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Verify CLAUDE.md exists
        run: test -f CLAUDE.md
      - name: Check commit message format
        run: |
          # Add conventional commit check
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Follow the commit conventions
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## 📄 License

This template is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Claude Code](https://code.anthropic.com/) by Anthropic
- [Conventional Commits](https://www.conventionalcommits.org/)
- The open-source community

## 🔗 Resources

- [Claude Code Documentation](https://code.anthropic.com/docs)
- [Conventional Commits Spec](https://www.conventionalcommits.org/)
- [GitHub CLI](https://cli.github.com/)
- [Git Best Practices](https://git-scm.com/book/en/v2)

## 💬 Support

- 📧 **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/claude-code-project-starter/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/claude-code-project-starter/discussions)
- 📖 **Documentation**: [Wiki](https://github.com/YOUR_USERNAME/claude-code-project-starter/wiki)

---

**Made with ❤️ and AI**

Start building better software with Claude Code today! 🚀

---

## Quick Reference

### Common Commands

| Command | Description |
|---------|-------------|
| `bash scripts/setup-claude-code.sh` | Initialize Claude Code configuration |
| Claude: "What Skills are available?" | List available skills |
| Claude: "Review my changes and create a commit" | Create formatted commit |
| Claude: "Create a PR" | Open pull request |
| Claude: "Clean up merged branches" | Delete merged branches |

### File Structure

```
Your Project/
├── .claude/          # Claude Code configuration
├── docs/             # Documentation
├── scripts/          # Automation scripts
├── src/              # Source code (your files)
└── CLAUDE.md         # Project standards
```

### Getting Help

1. Check `CLAUDE.md` for project standards
2. Review `docs/CLAUDE_CODE_ONBOARDING.md` for usage guide
3. Ask Claude Code: "Help me understand [topic]"
4. Create an issue on GitHub

Happy coding! 🎉
