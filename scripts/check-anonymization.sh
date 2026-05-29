#!/bin/bash
#
# 匿名化チェック
#
# 配布物に個人情報・固有名（氏名・所属・実プロダクト名・個人パス・個人運用・改編署名）が
# 混入していないかをスキャンする。検出したら一覧を表示して非ゼロ終了する。
# CI（.github/workflows/ci.yml）とローカルの両方で使う。
#
# 除外:
#   - LICENSE                 … MIT の著作者表記として実名を許容
#   - check-anonymization.sh  … このスクリプト自身が検出トークン一覧を含むため
#   - .git/
#
set -uo pipefail

cd "$(dirname "$0")/.." || exit 2
ROOT="$(pwd)"

# 検出対象トークン（ERE）。
# 注意:
#   - 個人ホームパス（`C:\Users\tatsu` / `C:/Users/tatsu`）と `C:\ideas` は厳密一致させる
#     （GitHub ユーザー名はリポジトリの公開アドレスそのものなので、`tatsu` 単体では検出しない）。
#   - 汎用の `ideas/` ディレクトリ機能は誤検出しない。
PATTERN='東城|立憲|Tatsunori|Tojo|onedrop|Shifree|シフリー|きろくる|Eumenes|広島大学|フクスケ|SharePoint|secretary|business-docs|career-master|shift-scheduler|attendance-desktop|correspondence-school|adapted by tojo|C:\\Users\\tatsu|C:/Users/tatsu|C:\\ideas'

HITS=$(grep -rInE "$PATTERN" "$ROOT" \
  --exclude-dir=.git \
  --exclude=LICENSE \
  --exclude=check-anonymization.sh 2>/dev/null || true)

if [ -n "$HITS" ]; then
  echo "NG: 個人情報・固有名の混入を検出しました。" >&2
  echo "$HITS" >&2
  echo "" >&2
  echo "配布物から除去するか、正当な理由（著作者表記など）があれば本スクリプトの除外対象を見直してください。" >&2
  exit 1
fi

echo "OK: 配布物に個人情報・固有名の混入なし"
exit 0
