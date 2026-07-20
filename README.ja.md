<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./assets/hero-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="./assets/hero-light.svg">
  <img alt="Reliable Ship — 速く作り、独立して問い直し、人間が慎重にmergeする" src="./assets/hero-light.svg">
</picture>

<h1 align="center">Reliable Ship</h1>

<p align="center"><strong>実際にリリースするソフトウェアのための、レビュー可能なClaude Codeワークフロー。</strong></p>

<p align="center">
  Claudeが実装し、別のレビュアーが反証し、人間が決める。
</p>

<p align="center">
  <a href="README.md">English</a> · <a href="README.ja.md">日本語</a>
</p>

<p align="center">
  <a href="https://github.com/tatsunoritojo/claude-code-project-starter/actions/workflows/ci.yml"><img src="https://github.com/tatsunoritojo/claude-code-project-starter/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <img src="https://img.shields.io/badge/Claude_Code-plugin-7C3AED" alt="Claude Code plugin">
  <img src="https://img.shields.io/badge/components-Markdown_only-0E7490" alt="Markdown-only plugin">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-334155" alt="MIT License"></a>
</p>

---

Claude Codeは速く実装できます。しかし、リリース可能な変更にするには、全員が次の4点へ答えられる必要があります。

1. 何を変更すると合意したか
2. 現在のcommitを何の根拠で「完了」と呼ぶか
3. 別のレビュアーが、そのcommit自体を問い直したか
4. merge / releaseの最終判断を誰が持つか

Reliable Shipは、この4点を明示的なスキルにします。巨大な仕様フレームワークではなく、単なるプロンプト集でもありません。

## 2コマンドで導入

Claude Codeの中で実行します。

```text
/plugin marketplace add tatsunoritojo/claude-code-project-starter
/plugin install reliable-ship@tojo-ai-workflows
```

必要と表示された場合は、プラグインを再読み込みします。

```text
/reload-plugins
```

> [!NOTE]
> プラグインの中身は、Markdownのスキル4個とテンプレート4個だけです。hook、MCPサーバー、実行バイナリ、バックグラウンド処理、自動mergeは追加しません。

## 4つのゲートを使う

| ゲート | コマンド | 作るもの | 止まる条件 |
|---|---|---|---|
| Frame | `/reliable-ship:frame` | 成果、非対象、受け入れ条件、base SHA | スコープや権限が曖昧 |
| Verify | `/reliable-ship:verify` | 受け入れ条件と根拠の対応表、HEAD SHA | 根拠が不足・矛盾 |
| Challenge | `/reliable-ship:review-brief` | Codex等の別レビュアーへ渡すレビュー資料 | 検証がない・古い |
| Decide | `/reliable-ship:merge-gate` | 最新の根拠、指摘、残存リスク、人間の判断欄 | レビュー対象SHAと現在HEADが違う |

<p align="center">
  <img src="./assets/workflow.svg" alt="Reliable Shipの4段階: frame, verify, challenge, decide">
</p>

通常は次の順で使います。

```text
/reliable-ship:frame
# 合意した範囲をClaude Codeが実装
/reliable-ship:verify
/reliable-ship:review-brief
# 生成した資料をCodexなど別のレビュアーへ渡す
/reliable-ship:merge-gate
# 人間がmerge / revise / holdを選ぶ
```

### 変えてはいけない不変条件

検証とレビューが有効なのは、cleanな状態で記録したcommit SHAに対してだけです。未コミット変更へ根拠を引き継ぐことはできません。HEADまたはworktreeが変わったら、変更をcommitしてから影響するゲートをもう一度通します。

これにより「承認後にコードを変更したのに、以前の承認が現在の状態にも効いているように見える」状態をゲートで検出します。

## すること／しないこと

| すること | しないこと |
|---|---|
| 1変更を人間が把握できる大きさに保つ | Issueを巨大な仕様書にする |
| 観察可能な受け入れ根拠を要求する | 「動くはず」を根拠にする |
| 中立な独立レビュー資料を作る | Claude自身の自己レビューを独立レビューと呼ぶ |
| 古くなったレビューSHAを検出する | 後続commitへ承認を引き継ぐ |
| 残存リスクを人間へ見せる | 人間に代わってmerge / releaseする |

Codexへ渡す資料は作れますが、このプラグイン自体はCodexを呼びません。独立性は、同じエージェントの呼び名を変えることではなく、別のレビュー文脈を使うことで生まれます。

## 同じゲートを持つリポジトリを始める

[`project-template/`](project-template/) には、リポジトリ側の土台を入れています。

- 簡潔な `CLAUDE.md`
- 1ページの `docs/01-overview.md`
- 追記専用のADR
- セッション開始時の文脈確認
- 人間サイズのAI支援変更Issueフォーム
- 根拠、レビュー対象SHA、人間判断欄を持つPRテンプレート

プレースホルダを置き換えて使います。

**macOS / Linux**

```bash
cp -R project-template/CLAUDE.md \
  project-template/docs \
  project-template/.claude \
  project-template/.github \
  /path/to/your-project/
```

**Windows PowerShell**

```powershell
Copy-Item -Recurse `
  project-template\CLAUDE.md, `
  project-template\docs, `
  project-template\.claude, `
  project-template\.github `
  C:\path\to\your-project\
```

プラグインがこれらを自動コピーすることはありません。リポジトリへ入れるものは人間が選びます。

このリポジトリ自身も同じIssue / PRテンプレートを `.github/` で使い、公開している運用を自分の保守へ適用します。

## スローガンではなく根拠

### 公開ケーススタディ

[MacKairu: changing a native macOS app without losing control](docs/case-study-mackairu.md) では、公開commitから次の変更を追えます。

- 日本語IMEの不具合修正
- 666行のViewと1,196行の状態オブジェクトの分割
- 構造変更フェーズで「挙動を変えない」を非対象として固定
- 純粋ロジックをテスト可能にし、記録上のテスト数を58から69へ拡大
- build、test、Codexレビューをcommitに記録

同時に限界も明記しています。これは観察的な履歴であり、レビュー全文は公開されておらず、生産性の改善率は主張しません。

### 再現可能な評価

[`evals/`](evals/) には、通常のClaude Codeとプラグイン利用時を同条件で比較するシナリオがあります。

- スコープ膨張
- 根拠のない完了報告
- 古いレビューSHA
- 見せかけの独立レビュー
- AIへのmerge権限の暗黙移譲

公開結果の状態は **未測定** です。振る舞いの効果を主張する前に、評価手順と生データ形式を先に公開しています。

### CIで確認するもの

- Linux / Windowsでのフルパック導入・削除
- 既存ルール、設定、同名スキル、同名hookの温存
- JSON構文とスキルfrontmatter
- Marketplace / plugin構造
- 必須ワークフロー・プロジェクトテンプレート
- shell scriptの致命的エラー
- 個人名・顧客固有名の意図しない混入

## 上級者向け: フルスタイルパック

公開導線としてはプラグインを推奨します。従来のフルパックも、グローバルルール、日本語の14スキル、プロジェクト既定値、起動時メッセージをまとめて入れたい人向けに残しています。

リポジトリをcloneまたはZIP展開して実行します。

**Windows PowerShell**

```powershell
.\install.ps1
.\install.ps1 -UserName "山田太郎" -UserRole "バックエンドエンジニア"
```

**macOS / Linux**

```bash
bash install.sh
USER_NAME="山田太郎" USER_ROLE="バックエンドエンジニア" bash install.sh
```

既定では破壊的に上書きしません。

- 既存の `CLAUDE.md` / `settings.json` は `.stylepack` の別ファイルへ出力
- 同名の既存スキルはスキップ
- 同名の既存hookはスキップ
- 強制置換時はバックアップ
- manifestに基づき、uninstallはパックが置いたものだけを対象化
- uninstallの既定はドライラン

<details>
<summary><strong>フルパックを削除する</strong></summary>

**Windows**

```powershell
.\uninstall.ps1
.\uninstall.ps1 -Yes
```

**macOS / Linux**

```bash
bash uninstall.sh
YES=1 bash uninstall.sh
```

`CLAUDE.md` と `settings.json` はユーザー編集があり得るため、自動削除しません。

</details>

## 構成

```text
.
├── .claude-plugin/             # Marketplaceカタログ
├── plugins/reliable-ship/      # Markdownのみの4スキル
├── project-template/           # CLAUDE.md、docs、Issue、PRの雛形
├── home-claude/                # 上級者向けフルパック（14スキル）
├── evals/                      # 振る舞い評価キット
├── docs/                       # 概要、ケーススタディ、ADR
├── assets/                     # ライト／ダーク画像、工程図、Social Preview
├── install.* / uninstall.*     # 安全なフルパック導入・削除
└── scripts/                    # 構造検証、匿名化チェック
```

## 設計原則

- **巨大Issueより小さな契約。** 実装や承認に影響することだけを書く。
- **自信より根拠。** 検証されるまで「完了」は主張にすぎない。
- **レビュー対象は不変。** 承認はbranch名ではなくSHAに属する。
- **役割ごとに文脈を分ける。** 実装と反証が同じ前提を共有しすぎない。
- **権限は人間に残す。** AIは提案できるが、merge / release責任を継承しない。

## ドキュメント

- [プロジェクト概要](docs/01-overview.md)
- [MacKairuケーススタディ](docs/case-study-mackairu.md)
- [評価手順](evals/README.md)
- [設計判断](docs/decisions/)
- [コントリビューション](CONTRIBUTING.md)
- [セキュリティ](SECURITY.md)

## ライセンス

MIT。詳細は [`LICENSE`](LICENSE) を参照してください。フルパックの一部スキルはMITライセンスの先行実装を改編しており、各 `SKILL.md` に由来を残しています。
