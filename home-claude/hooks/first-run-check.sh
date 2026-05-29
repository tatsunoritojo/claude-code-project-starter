#!/bin/bash
#
# 開発スタイルパック 初回起動チェック（オプション・既定では無効）
#
# ~/.claude/CLAUDE.md にプロフィールのプレースホルダが残っていれば、初回セットアップを促すバナーを出す。
# プレースホルダが埋まっていれば何も出さない（自己沈黙）。
#
# 有効化するには README の「オプション: 初回起動フック」を参照し、
# ~/.claude/settings.json の SessionStart にこのスクリプトを登録する。
# POSIX シェルが必要（macOS / Linux、Windows は Git Bash 等）。
#

GLOBAL_MD="$HOME/.claude/CLAUDE.md"

if [ -f "$GLOBAL_MD" ] && grep -q '{{USER_NAME}}' "$GLOBAL_MD" 2>/dev/null; then
  echo ""
  echo "[開発スタイルパック] プロフィールが未設定です。"
  echo "  Claude に「プロフィールを設定して」と頼むか、~/.claude/CLAUDE.md のプレースホルダ（{{...}}）を編集してください。"
  echo ""
fi

exit 0
