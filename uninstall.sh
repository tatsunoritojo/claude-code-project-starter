#!/bin/bash
#
# 開発スタイルパックのアンインストール（macOS / Linux）
#
# パックが入れたスキルと起動グリーティングフックを ~/.claude から取り除く。
# 既定はドライラン（削除内容の表示のみ）。実際に削除するには YES=1 を付ける:
#   bash uninstall.sh        … 何が消えるか表示するだけ
#   YES=1 bash uninstall.sh  … 実際に削除
#
# settings.json と CLAUDE.md は自分で編集している可能性があるため、自動では触らない。
#
set -euo pipefail

SRC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_SKILLS="$SRC_ROOT/home-claude/skills"
TARGET="$HOME/.claude"
YES="${YES:-0}"

echo "アンインストール対象: $TARGET"
[ "$YES" = "1" ] || echo "(ドライラン。実際に削除するには YES=1 を付けて実行)"
echo ""

remove_item() {
  local path="$1"
  [ -e "$path" ] || return 0
  if [ "$YES" = "1" ]; then
    rm -rf "$path"
    echo "  削除: ${path#"$TARGET"/}"
  else
    echo "  削除予定: ${path#"$TARGET"/}"
  fi
}

# パックが配布したスキルだけを対象にする（ユーザー自作の同名でないスキルは触らない）
if [ -d "$SRC_SKILLS" ]; then
  for s in "$SRC_SKILLS"/*/; do
    remove_item "$TARGET/skills/$(basename "$s")"
  done
fi

# 起動グリーティングフック
remove_item "$TARGET/hooks/session-greeting.sh"

echo ""
echo "手動で確認してください（自動では触りません）:"
echo "  - $TARGET/settings.json の hooks.SessionStart から session-greeting の登録を外す"
echo "  - $TARGET/CLAUDE.md は編集済みの可能性があるため残しています。不要なら手動削除、または .stylepack-backup-* から復元"
