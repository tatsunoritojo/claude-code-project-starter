#!/bin/bash
#
# 開発スタイルパックを ~/.claude へ展開するインストーラ（macOS / Linux）。
# home-claude/ 配下のグローバルルール・スキル・設定をユーザーの ~/.claude/ に展開する。
# 既存ファイルは破壊せず、衝突時はバックアップを取るか .stylepack 退避ファイルとして書き出す。
#
# 使い方:
#   bash install.sh                 通常インストール
#   FORCE=1 bash install.sh         既存の CLAUDE.md / settings.json / 同名スキルを上書き
#   USER_NAME="山田太郎" bash install.sh   プロフィールのプレースホルダを埋める
#
set -euo pipefail

SRC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_CLAUDE="$SRC_ROOT/home-claude"
TARGET="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$TARGET/.stylepack-backup-$STAMP"
FORCE="${FORCE:-0}"

if [ ! -d "$SRC_CLAUDE" ]; then
  echo "home-claude/ が見つかりません: $SRC_CLAUDE" >&2
  exit 1
fi

echo "開発スタイルパックを展開します -> $TARGET"
mkdir -p "$TARGET"

backup_if_exists() {
  local path="$1"
  if [ -e "$path" ]; then
    mkdir -p "$BACKUP_ROOT"
    cp -R "$path" "$BACKUP_ROOT/"
    echo "  バックアップ: $(basename "$path") -> $BACKUP_ROOT"
  fi
}

# --- CLAUDE.md ---
DST_MD="$TARGET/CLAUDE.md"
TMP_MD="$(mktemp)"
trap 'rm -f "$TMP_MD" "$TMP_MD.bak"' EXIT
cp "$SRC_CLAUDE/CLAUDE.md" "$TMP_MD"

# sed の置換文字列に含まれる特殊文字(/ & \)をエスケープしてから流し込む
sed_escape() { printf '%s' "$1" | sed -e 's/[\/&\\]/\\&/g'; }
if [ -n "${USER_NAME:-}" ]; then
  sed -i.bak "s/{{USER_NAME}}/$(sed_escape "$USER_NAME")/g" "$TMP_MD" && rm -f "$TMP_MD.bak"
fi
if [ -n "${USER_ROLE:-}" ]; then
  sed -i.bak "s/{{USER_ROLE}}/$(sed_escape "$USER_ROLE")/g" "$TMP_MD" && rm -f "$TMP_MD.bak"
fi
if [ -e "$DST_MD" ] && [ "$FORCE" != "1" ]; then
  cp "$TMP_MD" "$DST_MD.stylepack"
  echo "  既存 CLAUDE.md を温存。新ルールは $DST_MD.stylepack に書き出しました（手動マージするか FORCE=1 で上書き）"
else
  backup_if_exists "$DST_MD"
  cp "$TMP_MD" "$DST_MD"
  echo "  CLAUDE.md を配置しました"
fi
rm -f "$TMP_MD"

# --- settings.json ---
DST_SETTINGS="$TARGET/settings.json"
if [ -e "$DST_SETTINGS" ] && [ "$FORCE" != "1" ]; then
  cp "$SRC_CLAUDE/settings.json" "$DST_SETTINGS.stylepack"
  echo "  既存 settings.json を温存。推奨設定は settings.json.stylepack に書き出しました（permissions を手動マージ推奨）"
else
  backup_if_exists "$DST_SETTINGS"
  cp "$SRC_CLAUDE/settings.json" "$DST_SETTINGS"
  echo "  settings.json を配置しました"
fi

# --- skills ---
DST_SKILLS="$TARGET/skills"
mkdir -p "$DST_SKILLS"
for skill in "$SRC_CLAUDE/skills"/*/; do
  name="$(basename "$skill")"
  dst="$DST_SKILLS/$name"
  if [ -e "$dst" ] && [ "$FORCE" != "1" ]; then
    echo "  スキップ（既存）: skills/$name  ※上書きするには FORCE=1"
    continue
  fi
  if [ -e "$dst" ]; then
    backup_if_exists "$dst"
    rm -rf "$dst"
  fi
  cp -R "${skill%/}" "$dst"
  echo "  スキル配置: skills/$name"
done

# --- hooks（session-greeting は settings.json 経由で既定有効。無効化は README 参照） ---
SRC_HOOKS="$SRC_CLAUDE/hooks"
if [ -d "$SRC_HOOKS" ]; then
  DST_HOOKS="$TARGET/hooks"
  mkdir -p "$DST_HOOKS"
  for h in "$SRC_HOOKS"/*; do
    [ -f "$h" ] || continue
    cp "$h" "$DST_HOOKS/"
    chmod +x "$DST_HOOKS/$(basename "$h")"
    echo "  フック配置: hooks/$(basename "$h")"
  done
fi

echo ""
echo "完了しました。次の手順:"
echo "  1. ~/.claude/CLAUDE.md の「ユーザープロフィール」のプレースホルダ（{{USER_NAME}} 等）を自分の情報に書き換える"
echo "  2. Claude Code を再起動して設定を読み込む"
echo "  3. 'What Skills are available?' で同梱スキルの読み込みを確認する"
[ -d "$BACKUP_ROOT" ] && echo "  （上書きしたファイルのバックアップ: $BACKUP_ROOT）"
