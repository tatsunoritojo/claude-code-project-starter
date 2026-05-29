#!/bin/bash
#
# セッション起動フック
# Claude Code セッション開始時に、このプロジェクトの初動文脈を提示する。
# git 状態・必須ドキュメントの有無・依存未インストールを確認する。
#

# Claude Code 経由では CLAUDE_PROJECT_DIR が渡される。単体実行時は cwd を使う。
DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

echo ""
echo "=== $(basename "$DIR") ==="

# git 状態
if [ -d "$DIR/.git" ]; then
  BRANCH=$(cd "$DIR" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
  DIRTY=$(cd "$DIR" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  echo "ブランチ: $BRANCH（未コミット変更: ${DIRTY} 件）"
fi

# 必須ドキュメントの存在確認
[ -f "$DIR/CLAUDE.md" ]            && echo "CLAUDE.md: あり"            || echo "CLAUDE.md: なし（/doc-init で整備を検討）"
[ -f "$DIR/docs/01-overview.md" ] && echo "docs/01-overview.md: あり" || echo "docs/01-overview.md: なし（/doc-init で整備を検討）"

# 未処理アイディアの確認（任意運用。ideas/ がある場合のみ）
if [ -d "$DIR/ideas" ]; then
  PLACED=$(grep -rl '"status": *"placed"' "$DIR/ideas" 2>/dev/null | wc -l | tr -d ' ')
  [ "$PLACED" != "0" ] && echo "未処理アイディア: ${PLACED} 件（ideas/ を確認）"
fi

# 依存関係の未インストール検出（該当スタックがある場合のみ）
if [ -f "$DIR/package.json" ] && [ ! -d "$DIR/node_modules" ]; then
  echo "依存: 未インストール（npm install を検討）"
fi

echo "起動時の推奨: CLAUDE.md と docs/01-overview.md を読み、次セッション着手用の欄を確認する"
echo ""
exit 0
