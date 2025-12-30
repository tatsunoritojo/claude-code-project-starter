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
