---
name: repo-health-check
description: プロジェクト着手時の初動確認を一括実行する。プロジェクト構造、依存状態、git状態、主要ファイルを並列取得し、作業開始の文脈を構築する。逐次Readや探索的なlsを削減する目的で使用する。
allowed-tools: Bash(git:*), Bash(npm:*), Bash(pip:*), Bash(python:*), Bash(ls:*), Bash(cat:*), Read, Glob, Grep
model: sonnet
---

# Repo Health Check

プロジェクト着手時の初動確認スキル。
逐次的な探索を避け、必要な文脈を一括で取得する。

## 実行手順

### Step 1: プロジェクト検出

現在の作業ディレクトリ（cwd）から対象プロジェクトを特定する。

1. `CLAUDE.md` が存在するか確認 → 存在すれば読み込む
2. プロジェクトタイプを判定:
   - `package.json` → Node.js 系
   - `requirements.txt` or `pyproject.toml` → Python 系
   - `Cargo.toml` → Rust 系
   - 該当なし → 汎用

### Step 2: 基本情報の並列取得

以下を **1メッセージ内で並列に** 実行する（これが最重要）:

**すべてのプロジェクト共通:**
- `git status` — 未コミットの変更
- `git log --oneline -5` — 直近5コミット
- `git branch -a` — ブランチ一覧
- CLAUDE.md を Read（存在する場合）
- **アクティブな対応事項の検出**:
  - CLAUDE.md に「アクティブな対応事項」「現在進行中」「優先タスク」等のセクションがあれば、その内容を Step 3 出力で必ず先頭に提示する
  - `~/.claude/projects/<encoded_cwd>/memory/` に `project_*_<最新日付>.md` のような最近のクライアントフィードバック/面談メモがあれば、ファイル名を列挙する（中身は必要時のみ Read）

**Node.js プロジェクトの場合（追加）:**
- `package.json` を Read（scripts セクションに注目）
- `ls app/ 2>/dev/null || ls src/ 2>/dev/null` でトップレベル構造を取得（Glob はパス指定が効かないケースがあるため Bash を使う）
- `ls node_modules/.package-lock.json 2>/dev/null && echo installed || echo not installed` で依存確認

**Python プロジェクトの場合（追加）:**
- `requirements.txt` を Read
- `ls app/ 2>/dev/null || ls src/ 2>/dev/null` でトップレベル構造を取得
- `ls .env .env.local 2>/dev/null && echo found || echo not found` で設定確認

### Step 3: 構造サマリの出力

取得した情報を以下の形式で整理して出力する:

```
## [プロジェクト名] Health Check

### アクティブな対応事項（CLAUDE.md / memory から検出）
- CLAUDE.md にアクティブセクションがあれば全項目を列挙
- memory/ に直近のクライアントフィードバック等があればファイル名と日付を提示
- なければ「該当なし」と明示する

### Git状態
- ブランチ: xxx
- 未コミット変更: あり/なし
- 直近コミット: ...

### プロジェクト構造
- タイプ: Next.js / Flask / React+Vite / etc.
- エントリポイント: ...
- 主要ディレクトリ: ...

### 依存状態
- インストール済み: はい/いいえ
- ロックファイル: あり/なし

### 利用可能なコマンド
- dev: ...
- build: ...
- test: ...
- lint: ...

### 注意事項
- CLAUDE.md から抽出した禁止事項や特記事項
```

## 重要な原則

1. **並列実行を徹底する** — Step 2 の情報取得は必ず1メッセージ内で並列に呼ぶ。逐次 Read を絶対にしない
2. **CLAUDE.md を最優先で読む** — プロジェクト固有のルールが書かれている
3. **出力は簡潔に** — 探索結果をそのまま出すのではなく、作業開始に必要な情報だけ整理する
4. **不足があれば明示する** — 依存未インストール、env未設定など、作業開始前に必要なアクションがあれば列挙する
