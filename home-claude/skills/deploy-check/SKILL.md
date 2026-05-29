---
name: deploy-check
description: 修正完了後のデプロイ前確認を一括実行する。build、lint、test、git状態を確認し、デプロイ可能かどうかを判定する。毎回の確認手順を固定化し、終盤の迷いを減らす目的で使用する。
allowed-tools: Bash(git:*), Bash(npm:*), Bash(npx:*), Bash(pip:*), Bash(python:*), Bash(pytest:*), Bash(flask:*), Read, Glob, Grep
model: sonnet
---

# Deploy Check

修正完了後のデプロイ前確認スキル。
build / lint / test / git 状態を一括確認し、デプロイ可否を判定する。

## 実行手順

### Step 1: プロジェクト検出とコマンド特定

1. CLAUDE.md を読み、検証ルール・標準コマンドを確認する
2. プロジェクトタイプを判定し、使用するコマンドを決定する:

| プロジェクト | build | lint | test |
|---|---|---|---|
| Next.js | `npm run build` | `npm run lint` | なし |
| React+Vite | `npm run build` | なし | `npm run test` |
| Flask | なし | なし | `pytest` |

### Step 2: 並列実行

以下を **1メッセージ内で並列に** 実行する:

**Git 状態:**
- `git status` — 未コミット変更の確認
- `git diff --stat` — 変更ファイル一覧

**ビルド・テスト（プロジェクト別）:**

Node.js 系:
- `npm run build` — ビルド確認
- `npm run lint` — Lint確認（スクリプトが存在する場合）
- `npm run test` — テスト実行（スクリプトが存在する場合）

Python 系:
- `pytest --tb=short -q` — テスト実行（短縮出力）

### Step 3: 結果の判定と出力

```
## Deploy Check 結果

### ✓ / ✗ ビルド
[結果サマリ — エラーがあれば該当箇所を抜粋]

### ✓ / ✗ Lint
[結果サマリ]

### ✓ / ✗ テスト
[結果サマリ — 失敗テストがあれば名前を列挙]

### Git 状態
- ブランチ: xxx
- 未コミット変更: [ファイルリスト]
- コミット推奨: はい/いいえ

### 判定
🟢 デプロイ可能 / 🟡 要確認（理由） / 🔴 デプロイ不可（理由）
```

### 判定基準

- **🟢 デプロイ可能**: build 成功 + lint 警告のみ or なし + test 全パス + 変更がコミット済み
- **🟡 要確認**: build 成功だが、未コミット変更あり / lint 警告多数 / 一部テストスキップ
- **🔴 デプロイ不可**: build 失敗 / test 失敗 / TypeScript エラー

## 重要な原則

1. **並列実行を徹底する** — build, lint, test, git status は独立なので必ず並列実行
2. **結果は判定付きで出す** — 生ログをそのまま出さず、合否を明確にする
3. **エラー時は修正箇所を特定する** — 「build 失敗」で終わらず、該当ファイル・行を示す
4. **CLAUDE.md の検証ルールに従う** — プロジェクト固有の確認事項があればそれも含める
