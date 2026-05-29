# Claude Code 開発スタイルパック

Claude Code をペアプログラマーとして運用するためのグローバルルール・スキル・設定・プロジェクト雛形を1つにまとめた配布パッケージ。`~/.claude/` に展開して使う。

## 次セッション着手用
- 現在地: ピン留め公開ショーケースとして仕上げ完了。CI(Linux+Windows)・匿名化チェックスクリプト・アンインストール(マニフェスト方式)・README強化(バッジ/使用イメージ/FAQ)を追加し master へマージ。CI は master で緑。リポジトリ説明文・トピックも設定済み。Codex レビューを2巡（README系・自動化系）反映
- 次アクション: 別マシン/別ユーザーで install を実走させ体感確認。フィードバックがあれば反映
- 参照ファイル: `home-claude/CLAUDE.md`(スタイル本体), `home-claude/hooks/session-greeting.sh`, `install.ps1`/`install.sh`, `uninstall.*`, `scripts/check-anonymization.sh`, `.github/workflows/ci.yml`, `README.md`
- 未解決 / 別扱い: (1)グローバルから除外した個人色の強い要素（秘書/教材/3者協働）を汎用版で復活させるか未検討。(2)SessionStart の matcher 明示（startup 限定）は値の確証が取れたら追加検討。(3)インストーラに settings.json 自動マージ機能を持たせるかは別途。(4)匿名化スキャンのトークンは辞書語による誤検出を避け、固有名・個人パス中心に整理済み
- 最終更新: 2026-05-30

## このリポジトリの構成

- `home-claude/` — `~/.claude/` に展開される中身（グローバル CLAUDE.md / settings.json / skills）
- `project-template/` — 新規プロジェクトのルートにコピーする雛形
- `install.ps1` / `install.sh` — グローバル展開インストーラ
- 詳細は `docs/01-overview.md` を参照

## このプロジェクト固有の作業ルール

### 匿名化の鉄則（最重要）

このパッケージは**完全公開・匿名化前提**。個人情報・固有名を一切含めない。コミット前に必ず次のカテゴリの混入を grep で確認する:

- 個人の氏名（ローマ字・漢字表記）
- 所属企業名・派遣先名・業態名
- 個人のホームディレクトリパス（`C:\Users\<name>` など）や個人運用ディレクトリの絶対パス
- 実在プロダクト名・実在組織名
- 個人運用システムへの依存参照（秘書システム・案件管理・キャリア管理など）
- スキル原本に残る個人署名（`adapted by <name>` など）

具体的なスキャン用トークン一覧は、公開ファイルにベタ書きせず、メンテナの手元（git 管理外のローカルメモ）に置く。スキルや CLAUDE.md を追加・更新したら、このスキャンを完了判定に含める。

### 改行コード

`*.sh` は LF 固定（`.gitattributes` で強制）。CRLF だとフックや install.sh が `bad interpreter` で壊れる。

## このプロジェクトの完了判定（Definition of Done）

- [ ] 個人情報トークンの grep スキャンが 0 件
- [ ] `home-claude/` の skill 14個が揃っている
- [ ] install スクリプトがクリーンな ~/.claude（存在しない/既存あり）両方で安全に動く
- [ ] README のインストール手順が実際の挙動と一致している

## 関連ドキュメント

- 概要: `docs/01-overview.md`
- 設計判断（ADR）: `docs/decisions/`
- 使い方: `README.md`
