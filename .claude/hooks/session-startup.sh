#!/bin/bash
#
# セッション起動フック（このリポジトリ用）
#

DIR="$CLAUDE_PROJECT_DIR"

echo ""
echo "=== Claude Code 開発スタイルパック ==="

if [ -d "$DIR/.git" ]; then
  BRANCH=$(cd "$DIR" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
  DIRTY=$(cd "$DIR" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  echo "ブランチ: $BRANCH（未コミット変更: ${DIRTY} 件）"
fi

echo "起動時の推奨: CLAUDE.md（匿名化の鉄則）と docs/01-overview.md を読む"
echo "スキル/ルール変更時は個人情報トークンの grep スキャンを完了判定に含める"
echo ""
exit 0
