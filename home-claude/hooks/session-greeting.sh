#!/bin/bash
#
# 開発スタイルパック セッショングリーティング（既定で有効）
#
# 毎セッション開始時に、パックが有効であることと現在の状態を1行で示す。
# プロフィール未設定（プレースホルダが残っている）なら初回セットアップ案内を追記する。
#
# 無効化するには ~/.claude/settings.json の SessionStart から本フックの登録を外す。
# POSIX シェルが必要（macOS / Linux、Windows は Claude Code が用いるシェル）。
#

CLAUDE_DIR="$HOME/.claude"
GLOBAL_MD="$CLAUDE_DIR/CLAUDE.md"
SKILLS_DIR="$CLAUDE_DIR/skills"

# スキル数（skills 配下のディレクトリ数）
if [ -d "$SKILLS_DIR" ]; then
  SKILL_COUNT=$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
else
  SKILL_COUNT=0
fi

# プロフィール状態
if [ -f "$GLOBAL_MD" ] && grep -q '{{USER_NAME}}' "$GLOBAL_MD" 2>/dev/null; then
  PROFILE="未設定"
else
  PROFILE="設定済み"
fi

echo ""
echo "[開発スタイルパック] 有効 ｜ skills: ${SKILL_COUNT} ｜ profile: ${PROFILE}"

if [ "$PROFILE" = "未設定" ]; then
  echo "  初回セットアップ: Claude に「プロフィールを設定して」と頼むか、~/.claude/CLAUDE.md のプレースホルダ（{{...}}）を編集してください。"
fi

echo ""
exit 0
