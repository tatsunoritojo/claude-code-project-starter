# Claude Code 開発スタイルパック

> インストールすると、一貫したペアプログラミング型の Claude Code 運用スタイルを、どの環境でも同じように再現できる設定パック。

このリポジトリは、Claude Code を「対等なペアプログラマー」として運用するための**グローバルルール・スキル・設定・プロジェクト雛形**を1つにまとめたもの。`~/.claude/` に展開することで、影響範囲ベースの実行ポリシー（Green/Yellow/Red）、一次資料優先の規律、ドキュメント整備標準、段階的な進め方といった運用スタイルが、誰の環境でも同じように立ち上がる。

固有名・個人情報は含まない匿名化済みパック。プロフィール部分だけ各自で埋めて使う。

## 何が入っているか

```
claude-code-project-starter/
├── install.ps1 / install.sh     # ~/.claude へ展開するインストーラ
├── home-claude/                 # → ~/.claude/ に展開される中身
│   ├── CLAUDE.md                # 全セッション共通のグローバルルール（スタイル本体）
│   ├── settings.json            # 安全な読み取り系コマンドを既定許可
│   ├── skills/                  # 汎用スキル14個
│   └── hooks/                   # オプションのフック（既定では無効）
└── project-template/            # → 新規プロジェクトのルートへコピーして使う雛形
    ├── CLAUDE.md                # プロジェクト用 CLAUDE.md（穴埋め式）
    ├── docs/01-overview.md      # 1ページ概要テンプレ
    ├── docs/decisions/          # ADR（設計判断記録）の雛形
    └── .claude/                 # プロジェクト用 settings + セッション起動フック
```

### グローバルルール（スタイル本体）

`home-claude/CLAUDE.md` が運用スタイルの中心。主な内容:

- **影響範囲ベースの実行ポリシー（Green/Yellow/Red）** — 安全な操作は無確認、影響のある操作は簡潔に説明して実行、破壊的・不可逆な操作は事前確認
- **一次資料・ファクトチェック原則** — 推測で断定しない、出典明示、`file.py:91-103` 形式での引用
- **完了判定（Definition of Done）** — lint/test/build 通過は必要条件であって十分条件ではない
- **進捗の可視化・小刻み進行** — 中規模以上は Phase に分け、各 Phase 末に承認接点を置く
- **ドキュメント整備ルール** — CLAUDE.md + docs/01-overview.md + ADR の必須3点構成
- **ルール衝突時の優先順位** — 安全性 > 一次資料 > 体験影響 > 進捗可視化 > 簡潔さ

### 同梱スキル（14個）

| スキル | 用途 |
|---|---|
| `exec-boundary-guard` | 操作実行前に Green/Yellow/Red を判定 |
| `design-actor-impact` | 設計変更をアクター視点で影響評価 |
| `handoff-closeout` | セッション終了時の引き継ぎ処理 |
| `repo-health-check` | プロジェクト着手時の初動確認 |
| `deploy-check` | デプロイ前の build/lint/test 一括確認 |
| `doc-init` | 必須ドキュメント3点の整備 |
| `incident-response` | 本番障害対応（Plan B + Plan A 並行） |
| `db-audit` | DB 設計レビュー（制約・運用・観測） |
| `database-migration-review` | zero-downtime マイグレーションのレビュー |
| `search-first` | 実装前に既存コード・一次情報を確認 |
| `strategic-compact` | 長セッションでの compact 判断支援 |
| `mermaid-sequence-diagram` | 動作フローのシーケンス図可視化 |
| `readme-portfolio` | 対外公開向け README の作成 |
| `git-github-workflow` | コミット・ブランチ・PR ワークフロー |

## インストール

### Windows (PowerShell)

```powershell
.\install.ps1
# プロフィールを同時に埋める場合:
.\install.ps1 -UserName "山田太郎" -UserRole "バックエンドエンジニア"
# 既存の ~/.claude/CLAUDE.md 等を上書きする場合（バックアップは自動取得）:
.\install.ps1 -Force
```

### macOS / Linux

```bash
bash install.sh
# プロフィールを同時に埋める場合:
USER_NAME="山田太郎" USER_ROLE="バックエンドエンジニア" bash install.sh
# 上書きする場合:
FORCE=1 bash install.sh
```

インストーラの挙動:
- `~/.claude/CLAUDE.md` と `settings.json` が**既に存在する場合は上書きしない**。推奨内容を `*.stylepack` として書き出すので、手動マージするか `-Force` / `FORCE=1` で上書きする（その際は自動でバックアップを取る）
- スキルは同名が既存ならスキップ（`-Force` で上書き、バックアップあり）

インストール後、`~/.claude/CLAUDE.md` の「ユーザープロフィール」にあるプレースホルダを自分の情報に書き換える。インストーラが自動で埋めるのは `{{USER_NAME}}` と `{{USER_ROLE}}` の2つだけ（引数を渡した場合）。`{{USER_BACKGROUND}}` と `{{USER_DEV_STYLE}}` は手動で編集する。

## 初回起動の挙動

プロフィールのプレースホルダ（`{{USER_NAME}}` 等）が残ったまま Claude Code を起動すると、グローバル CLAUDE.md の「起動時セルフチェック」により、Claude が**未セットアップと判断して初回セットアップを能動的に提案**する。プロフィール4項目を尋ねて `~/.claude/CLAUDE.md` を埋め、利用可能なスキルを一覧で確認する。プレースホルダが埋まれば、このセルフチェックは二度と発火しない（自己沈黙）。

具体的な依頼を伴って起動した場合は、その依頼が優先され、セットアップは1行の提案に留まる。

### オプション: 初回起動フック

CLAUDE.md のセルフチェックに加えて、起動時に**決定的なバナー**でセットアップ未完了を知らせたい場合は、同梱のフックを有効化できる（既定では無効）。POSIX シェルが必要（macOS / Linux、Windows は Git Bash 等）。

`~/.claude/settings.json` に次を追加（既存の `hooks` があればマージ）:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "\"$HOME\"/.claude/hooks/first-run-check.sh" }
        ]
      }
    ]
  }
}
```

フック本体は `~/.claude/hooks/first-run-check.sh`（インストーラが配置済み）。プロフィールが埋まっていれば何も出力しない。

## 新規プロジェクトでの雛形の使い方

新しいプロジェクトを始めるときは `project-template/` の中身をプロジェクトのルートにコピーする。

```bash
cp -r project-template/CLAUDE.md project-template/docs project-template/.claude /path/to/your-project/
```

コピー後、`CLAUDE.md` と `docs/01-overview.md` の `{{...}}` プレースホルダを埋める。グローバルルールは `~/.claude/CLAUDE.md` 側で適用されるので、プロジェクト側には固有情報だけを書く。

## 手動インストール（スクリプトを使わない場合）

1. `home-claude/CLAUDE.md` を `~/.claude/CLAUDE.md` にコピー（既存があればマージ）
2. `home-claude/skills/*` を `~/.claude/skills/` にコピー
3. `home-claude/settings.json` の permissions を `~/.claude/settings.json` にマージ
4. `~/.claude/CLAUDE.md` のプロフィールを編集
5. Claude Code を再起動

## ライセンス

MIT License（[LICENSE](LICENSE) 参照）。一部スキルは MIT ライセンスの先行実装を改編して含む（各 SKILL.md の `origin` を参照）。
