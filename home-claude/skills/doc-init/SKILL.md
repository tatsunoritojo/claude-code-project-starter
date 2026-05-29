---
name: doc-init
description: プロジェクトのドキュメント整備状態を点検し、欠けていれば初期版生成を提案するスキル。CLAUDE.md / docs/01-overview.md / docs/decisions/ の必須3点を対象とする。プロジェクトディレクトリで作業を始める際、必須ドキュメントが揃っていない場合に呼び出す。
allowed-tools: Read, Write, Glob, Grep, Bash(ls:*), Bash(mkdir:*), Bash(find:*), Agent
model: sonnet
---

# Doc Init（プロジェクトドキュメント初期化）

プロジェクトディレクトリで作業を開始する際、グローバルCLAUDE.mdに定められた必須ドキュメント3点（`CLAUDE.md` / `docs/01-overview.md` / `docs/decisions/`）の整備状態を点検し、欠けているものを初期生成提案するスキル。

## 起動条件

- プロジェクトディレクトリで Claude Code を起動した直後、必須ドキュメントの欠落が検出されたとき
- ユーザーが明示的に「ドキュメント整備して」「doc-init」と指示したとき
- `idea-capture` 秘書スキルから「該当プロジェクトに 01-overview.md が無い」と通知されたとき

## 大原則

1. **既存ファイルを上書きしない**。あればスキップ、なければ提案
2. **ユーザー承認なしに書かない**。点検結果を提示し、生成許可を得てから書く
3. **一気に全部作らない**。3点それぞれ独立して提案・確認する
4. **ADR ディレクトリは空でも作る**（既存ADRは絶対に触らない）
5. **既存のプロジェクト構造から推論する**。コードや既存メタファイル（`package.json` 等）を読んで初期版を組み立てる

## 実行フロー

### Step 1: 点検

並列に以下を確認:

1. `<project>/CLAUDE.md` の存在
2. `<project>/docs/01-overview.md` の存在
3. `<project>/docs/decisions/` の存在
4. `<project>/README.md` の存在（参考情報）
5. `<project>/package.json` / `pyproject.toml` / `requirements.txt` / `Cargo.toml` 等の存在（推論材料）

### Step 2: 結果提示

```
■ ドキュメント整備状況

プロジェクト: <project>

[OK]  CLAUDE.md
[NG]  docs/01-overview.md
[NG]  docs/decisions/

生成提案できる候補: 01-overview.md, decisions/（空ディレクトリ）

それぞれ生成しますか？
```

### Step 3: コンテキスト収集（生成提案時のみ）

ユーザーが「生成して」と承認した項目のみ、必要な情報を集める。**広範な調査は Explore サブエージェントに quick で委譲する**（メイン文脈を汚さない）。

収集対象:
- README.md の内容
- package.json / pyproject.toml の name, description, scripts, dependencies
- 主要ディレクトリ構造（Glob で `src/`, `app/`, 等を確認）
- 主要エントリポイント（`main.*`, `app.*`, `index.*`, `server.*` 等）

### Step 4: 初期版生成

各テンプレートを基に初期版を組み立てる。**完璧を目指さない**。「ユーザーが校正することを前提とした下書き」を提供する。

#### CLAUDE.md テンプレート

`templates/CLAUDE.md.template` を使う。プレースホルダを埋める。

**「次セッション着手用」セクションの扱い**: テンプレートには「次セッション着手用」セクション（現在地 / 次アクション / 参照ファイル / 未解決 / 最終更新）が含まれる。**このセクションは初期生成時は空のまま** にする。プロジェクトのセッションを重ねるなかでグローバル「セッション終了時の規律」に従って埋まっていく欄なので、初期推測で項目を埋めない。

**Definition of Done セクションの扱い**: テンプレートには「このプロジェクトの完了判定（Definition of Done）」セクションが含まれる。`{{PROJECT_DOD_REAL_ENV_CHECK}}` と `{{PROJECT_DOD_DOMAIN_SPECIFIC}}` のプレースホルダは、プロジェクトの性質から推論して下書きを入れる:

- DB を持つプロジェクト → 「production DB に migration 適用 + 該当機能を画面で確認」など
- 外部連携があるプロジェクト → 「webhook 受信 / 送信の実機テスト」など
- フロントエンドのみのプロジェクト → 「主要画面でのレンダリング確認 + Lighthouse スコア確認」など
- 案件固有の項目が思いつかない場合は `{{PROJECT_DOD_DOMAIN_SPECIFIC}}` プレースホルダ行ごと削除する

ユーザーには「DoD は校正対象。実機/実環境の確認項目は案件で具体化してください」と促す。

#### 01-overview.md テンプレート

`templates/01-overview.md.template` を使う。プレースホルダを埋める。

#### decisions/ ディレクトリ

1. `mkdir -p <project>/docs/decisions` でディレクトリ作成
2. `<project>/docs/decisions/README.md` を `~/.claude/skills/doc-init/templates/decisions-README.md.template` から配置
   - 空ディレクトリは git で追跡されないため、README で実体化させる目的を兼ねる
   - ADR規約（命名・形式）の簡潔な説明を含む
3. 最初の ADR ファイル本体は実際の設計判断が発生したときに作る（このスキルでは作らない）

### Step 5: ユーザー承認 → 書き込み

各ファイルの初期版を提示:

```
■ docs/01-overview.md（初期版・要校正）

# <project>

## 何を解決するか
<推論内容>

## 誰のためか
<推論内容>

## 主要概念
- ...

このまま書き込みますか？修正しますか？
```

承認後に Write ツールで配置。

### Step 6: 報告

```
配置完了:
- docs/01-overview.md（要校正）
- docs/decisions/（空ディレクトリ）

次のアクション:
- 01-overview.md をユーザー自身の言葉で校正してください（特に「主要概念」と「状態」）
- 設計判断を伴う変更を加えたら、docs/decisions/ にADRを追加してください
```

## テンプレート

以下のテンプレートを `templates/` に配置済み:

- `templates/CLAUDE.md.template` — プロジェクトCLAUDE.md雛形
- `templates/01-overview.md.template` — 01-overview.md雛形
- `templates/ADR.md.template` — ADR雛形（実際にADRを書くとき参照）

## 注意点

- **既存プロジェクト ≠ 必ず全部生成すべき**。プロジェクトの規模・性質によっては「CLAUDE.md だけで十分」のケースもある。ユーザー判断を尊重する
- **生成内容は推論を含む**。「~~と思われます」のようにヘッジを入れず、明確な下書きを書くが、必ず「校正してください」と促す
- **ADR は機械生成しない**。既存コードから「これがADR候補だ」と推測して書くと、後付けの正当化になりやすい。実際に判断するタイミングで人間が書くべき
- **README.md と CLAUDE.md の使い分け**: README は外部向け（GitHub訪問者）、CLAUDE.md は Claude Code 向けのプロジェクト指示書。内容は重複するが視点が違う。両方ある場合は CLAUDE.md を優先して読む
