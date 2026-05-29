#!/bin/bash
#
# 開発スタイルパックのアンインストール（macOS / Linux）
#
# インストール時に記録したマニフェスト（~/.claude/.stylepack-manifest）に載っている
# ものだけを取り除く。ユーザー自前の同名スキルや手で置いたファイルには触らない。
# 既定はドライラン（削除内容の表示のみ）。実際に削除するには YES=1 を付ける:
#   bash uninstall.sh        … 何が消えるか表示するだけ
#   YES=1 bash uninstall.sh  … 実際に削除
#
# settings.json と CLAUDE.md は自分で編集している可能性があるため、自動では触らない。
#
set -euo pipefail

TARGET="$HOME/.claude"
MANIFEST="$TARGET/.stylepack-manifest"
YES="${YES:-0}"

echo "アンインストール対象: $TARGET"

if [ ! -f "$MANIFEST" ]; then
  echo ""
  echo "マニフェスト（$MANIFEST）が見つかりません。"
  echo "このパックの導入記録がないため、自動削除は行いません。"
  echo "手動で確認する場合は ~/.claude/skills と ~/.claude/hooks/session-greeting.sh を見てください。"
  exit 0
fi

[ "$YES" = "1" ] || echo "(ドライラン。実際に削除するには YES=1 を付けて実行)"
echo ""

removed_any=0
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  path="$TARGET/$rel"
  [ -e "$path" ] || continue
  if [ "$YES" = "1" ]; then
    rm -rf "$path"
    echo "  削除: $rel"
  else
    echo "  削除予定: $rel"
  fi
  removed_any=1
done < "$MANIFEST"

[ "$removed_any" = "1" ] || echo "  （マニフェストに記載の項目は既に存在しません）"

if [ "$YES" = "1" ]; then
  rm -f "$MANIFEST"
  echo "  削除: .stylepack-manifest"
fi

echo ""
echo "手動で確認してください（自動では触りません）:"
echo "  - $TARGET/settings.json の hooks.SessionStart から session-greeting の登録を外す"
echo "  - $TARGET/CLAUDE.md は編集済みの可能性があるため残しています。不要なら手動削除、または .stylepack-backup-* から復元"
