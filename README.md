<h1 align="center">Claude Code 開発スタイルパック</h1>

<p align="center"><b>Claude Code を、いきなり「気の利く相棒」にする設定パック</b></p>

<p align="center">経験のある開発者が Claude Code に仕込んでいる「働き方のルール」一式を、<br>そのまま自分の環境にコピーできます。</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey" alt="Platform">
  <img src="https://img.shields.io/badge/setup-3%20steps-brightgreen" alt="Setup">
</p>

---

## 入れると何が変わるか

同じ Claude Code でも、働き方がこう変わります。

| 場面 | パック導入前 | パック導入後 |
|---|---|---|
| 本番反映・ファイル削除・強制 push（履歴の上書き） | そのまま実行されることがある | **必ず一言確認してから**進める |
| 調べもの・テスト実行・コード読み | 都度許可を求めて止まりがち | いちいち聞かず**サッと自走** |
| 回答の根拠 | 「たぶんこう」で答えることも | **コードや公式ドキュメントを確認**してから答える |
| 完了の報告 | 「動くはず」で終わりがち | **ビルド・テストを確かめて**から完了 |
| 作業の終わり | 文脈が流れて消える | **引き継ぎメモ**を残す |
| 新規プロジェクト | 何もない状態から | 説明ファイルの**ひな型が最初から**そろう |

匿名化してあるので、誰が使っても大丈夫です。

> [!TIP]
> 一言でいうと「良い初期設定をゼロから書かなくて済む」パックです。Claude Code を入れたばかりで使いこなし方が分からない人ほど効きます。

## こんな人におすすめ

- Claude Code を使い始めたばかりで、**どう設定すればうまく使えるか**が分からない人
- Claude に**いきなり危ない操作**をされないか不安な人
- 毎回ゼロから指示を書くのに疲れて、**良い初期設定**がほしい人
- 複数のプロジェクトやマシンで**同じ使い心地に揃えたい**人

## 使い始める（3ステップ）

### 1. ダウンロード

このリポジトリを `git clone` するか、ZIP でダウンロードして展開します。

### 2. インストール

中身を Claude Code の設定フォルダ（`~/.claude/`。Windows では `C:\Users\あなた\.claude\`）へ展開します。付属スクリプトが自動でやります。

**Windows（PowerShell）**

```powershell
.\install.ps1
# 名前と役割を最初から入れておく場合:
.\install.ps1 -UserName "山田太郎" -UserRole "バックエンドエンジニア"
```

**macOS / Linux**

```bash
bash install.sh
# 名前と役割を最初から入れておく場合:
USER_NAME="山田太郎" USER_ROLE="バックエンドエンジニア" bash install.sh
```

> [!IMPORTANT]
> スクリプトは**今ある設定を勝手に上書きしません**。
> - `CLAUDE.md` と `settings.json` がすでにある場合は、新しい内容を `〜.stylepack` という別ファイルに書き出すので、見比べてから取り込めます。
> - 同じ名前のスキルがすでにある場合は、上書きせずスキップします（`-Force` を付けたときだけ、バックアップを取ってから入れ替え）。

### 3. Claude Code を再起動

起動時にこの1行が出れば、パックが効いています。

```text
[開発スタイルパック] 有効 ｜ skills: 14 ｜ profile: 設定済み
```

まだ自己紹介（プロフィール）が未入力なら `profile: 未設定` と出て、Claude が「プロフィールを設定しましょうか？」と声をかけます。名前・役割などを答えるだけで、Claude が設定ファイルを書き込みます。

---

## もう少し詳しく

### インストールすると入るもの

- **働き方のルール** — 全プロジェクトで Claude が守る共通の作業ルール（上の表の中身）
- **スキル14個** — よく使う作業を手順化したもの。「コミットを作って」「デプロイ前チェック」などと頼むと、その手順で動きます
- **新規プロジェクト用のひな型** — 新しいプロジェクトに置くと説明ファイルが最初から整います

<details>
<summary><b>付いてくるスキル一覧（14個）</b></summary>

<br>

| スキル | 何をしてくれるか |
|---|---|
| `exec-boundary-guard` | 操作の危険度を判定し、危ないものだけ確認する |
| `design-actor-impact` | 設計変更が「誰の使い勝手に影響するか」を整理する |
| `handoff-closeout` | 作業終わりに引き継ぎメモを残す |
| `repo-health-check` | プロジェクト着手時の初動チェック |
| `deploy-check` | デプロイ前にビルド・テスト・状態をまとめて確認 |
| `doc-init` | プロジェクトの説明ファイルを整える |
| `incident-response` | 本番障害のとき、復旧と原因究明を並行で進める |
| `db-audit` | データベース設計をレビューする |
| `database-migration-review` | DB のスキーマ変更（テーブル構造の変更）を安全に行う設計をレビュー |
| `search-first` | 自作で書き始める前に、既存コードや一次情報を調べる |
| `strategic-compact` | 長い会話を整理するタイミングを判断する |
| `mermaid-sequence-diagram` | 処理の流れを図（シーケンス図）にする |
| `readme-portfolio` | 公開向けの README を作る |
| `git-github-workflow` | コミット・ブランチ・プルリクの操作 |

</details>

### インストール後にやること

設定フォルダの `~/.claude/CLAUDE.md` を開き、冒頭の「ユーザープロフィール」を自分の情報に書き換えます（Claude に「プロフィールを設定して」と頼めば、聞きながら書き込みます）。

スクリプトに `-UserName` / `USER_NAME` を渡した場合は、名前と役割は自動で埋まります。残りの「専門・背景」「開発スタイル」は手で書き足してください。

> [!NOTE]
> 応答の言語は**日本語が既定**です。英語で使いたい場合は `~/.claude/CLAUDE.md` の「出力ルール」の言語欄を書き換えます。

### 新しいプロジェクトでひな型を使う

新しいプロジェクトを始めるときは、`project-template/` の中身をプロジェクトのフォルダにコピーします（エクスプローラーやFinderで手作業でコピーしても構いません）。

**macOS / Linux**

```bash
cp -r project-template/CLAUDE.md project-template/docs project-template/.claude /path/to/your-project/
```

**Windows（PowerShell）**

```powershell
Copy-Item -Recurse project-template\CLAUDE.md, project-template\docs, project-template\.claude C:\path\to\your-project\
```

コピーした `CLAUDE.md` と `docs/01-overview.md` の `{{ }}` の部分を埋めれば、そのプロジェクトの説明が整います。

### 起動時のあいさつを消したいとき

起動時の1行（グリーティング）は既定で有効です。不要なら `~/.claude/settings.json` の `hooks` の `SessionStart` から `session-greeting.sh` の登録を消します。あいさつが出なくても、ルールやスキルは問題なく動きます。

> [!NOTE]
> あいさつの表示にはシェル（macOS / Linux、または Windows で Claude Code が使うシェル）が必要です。シェルが使えない環境では、あいさつが出ないだけで他は通常どおり動きます。

<details>
<summary><b>フォルダ構成</b></summary>

<br>

```
claude-code-project-starter/
├── install.ps1 / install.sh     # 設定フォルダへ展開するスクリプト
├── home-claude/                 # → ~/.claude/ に入る中身
│   ├── CLAUDE.md                # 全プロジェクト共通の働き方ルール
│   ├── settings.json            # 許可コマンドと起動時あいさつの設定
│   ├── skills/                  # スキル14個
│   └── hooks/                   # 起動時あいさつのスクリプト
└── project-template/            # → 新しいプロジェクトに置くひな型
```

</details>

<details>
<summary><b>スクリプトを使わず手動で入れる</b></summary>

<br>

1. `home-claude/CLAUDE.md` を `~/.claude/CLAUDE.md` にコピー（既存があれば見比べてマージ）
2. `home-claude/skills/*` を `~/.claude/skills/` にコピー
3. `home-claude/hooks/*` を `~/.claude/hooks/` にコピー（`session-greeting.sh` を実行可能にする）
4. `home-claude/settings.json` の `permissions` と `hooks`（起動時あいさつ）を `~/.claude/settings.json` にマージ
5. `~/.claude/CLAUDE.md` のプロフィールを編集
6. Claude Code を再起動

</details>

## ライセンス

MIT License（[LICENSE](LICENSE) 参照）。一部のスキルは MIT ライセンスの先行実装を改編して含みます（各 `SKILL.md` の `origin` を参照）。
