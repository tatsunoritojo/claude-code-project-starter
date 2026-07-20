# Reliable Ship / Claude Code Project Starter

AI支援開発を「小さく合意する → 根拠を確認する → 別文脈で反証する → 人間が決める」の4ゲートで運用する公開パッケージ。推奨導線はMarkdownのみのClaude Codeプラグイン。従来のグローバルルール・14スキル・設定・雛形は上級者向けフルパックとして維持する。

## 次セッション着手用

- 現在地: v1.0再設計を `agent/relaunch-v1` に実装し、Linuxの安全テスト、公開構造validator、匿名化、現行Claude Code CLI 2.1.215のmanifest検証と隔離HOMEへのplugin installまで完了
- 次アクション: ドラフトPRを作成し、GitHub ActionsのLinux / Windows結果と人間レビューを確認する
- 参照ファイル: `README.md`, `README.ja.md`, `plugins/reliable-ship/`, `project-template/`, `evals/`, `docs/case-study-mackairu.md`, `scripts/validate-repository.py`
- 未解決 / 別扱い: Claude Code 2.1.215でmanifest strict検証と一時HOMEへのplugin installは成功。対話セッションでの4スキル実走とWindows CIはPR上で確認する。評価結果は未測定のまま公開し、結果を捏造しない
- 最終更新: 2026-07-20

## このリポジトリの構成

- `.claude-plugin/` — Marketplaceカタログ
- `plugins/reliable-ship/` — 推奨導線。Markdownのみの4ゲート
- `project-template/` — 新規/既存プロジェクトへコピーする雛形
- `home-claude/` — `~/.claude/` に展開する上級者向けフルパック
- `evals/` — 振る舞い比較の固定手順と生データ形式
- `assets/` — READMEとSocial Previewの視覚素材
- `install.ps1` / `install.sh` — フルパックのグローバル展開インストーラ
- 詳細: `docs/01-overview.md`

## このプロジェクト固有の作業ルール

### 匿名化の鉄則（最重要）

このパッケージは完全公開前提。個人情報・顧客固有情報を配布物へ混入させない。コミット前に `scripts/check-anonymization.sh` を実行する。

- 個人の氏名（ライセンス著作者表記を除く）
- 所属企業・顧客・非公開プロダクト名
- 個人ホームディレクトリの絶対パス
- 個人運用システムへの依存
- スキル原本の個人署名

検出トークン一覧を追加する場合、辞書語の誤検出と公開情報の扱いを確認する。

### 改行コード

`*.sh` はLF固定。CRLFではhookやinstallerが `bad interpreter` で壊れる。`.gitattributes` を維持する。

### 公開主張の根拠

- 効果・速度・品質の数値を、生データなしに記載しない
- ケーススタディは公開commitから確認できる事実と、確認できない限界を分ける
- `evals/results/` は実行前に「未測定」と明示し、結果を見てから評価手順を書き換えない

### プラグインの権限境界

- 推奨プラグインはMarkdownのskills/templatesのみとし、hook・MCP・実行ファイルを暗黙追加しない
- 独立レビューは別レビュアーへ渡す資料作成まで。自己レビューを独立レビューと呼ばない
- `merge-gate` は判断材料を作るだけで、merge / release / deployを実行しない
- reviewed SHAとcurrent HEADが違う場合は必ず古いレビューとして扱う

### リリース整合

- Marketplaceとplugin manifestのversionを揃える
- SVGを視覚素材の原本とし、`assets/social-preview.png` はdark heroから1280×640で再生成する
- 英語READMEを既定、日本語READMEを完全な第2導線として維持する
- 既存ADRは原則変更せず、新しい判断は新規ファイルへ追記する

## このプロジェクトの完了判定（Definition of Done）

- [ ] 個人情報トークンのgrepスキャンが0件
- [ ] `scripts/validate-repository.py` が成功する
- [ ] `plugins/reliable-ship/` の4スキルと4テンプレートが揃っている
- [ ] `home-claude/` のskill 14個が揃っている
- [ ] install scriptがクリーンな `~/.claude` と既存設定ありの両方で安全に動く
- [ ] READMEのplugin / full-pack手順が実際の構成と一致する
- [ ] 英日READMEのライト/ダーク画像とリンクが成立する
- [ ] 公開ケーススタディの事実リンクと限界が明示される

## 関連ドキュメント

- 概要: `docs/01-overview.md`
- ケーススタディ: `docs/case-study-mackairu.md`
- 評価: `evals/README.md`
- 設計判断: `docs/decisions/`
- リリース: `docs/release-checklist.md`
- 使い方: `README.md` / `README.ja.md`
