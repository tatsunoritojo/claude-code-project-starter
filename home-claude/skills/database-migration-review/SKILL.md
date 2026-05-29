---
name: database-migration-review
description: DB migration を zero-downtime(expand-contract)前提でレビュー・設計する汎用スキル。本番DB操作・破壊的変更・データ削除・大規模UPDATEは Red 扱いで確認ゲートを通す。Flask/Alembic・Django・Prisma・PostgreSQL・SQLite・Google Sheets連携を意識。
origin: ECC database-migrations (MIT)
---

# DB Migration レビュー / 設計

migration を「書く前にレビューし、安全に適用する」ための汎用スキル。ORM に依存しない原則を核にし、フレームワーク固有手順はクイックリファレンスで補う。

## 起動条件

- migration ファイルを新規作成・変更するとき
- 既存スキーマにカラム追加/変更/削除、インデックス、制約を加えるとき
- データ移行（backfill・大規模 UPDATE/DELETE）を行うとき
- 本番 DB に対する操作を計画するとき

## 鉄則

1. **書く前に既存を見る（search-first）。** 既存 migration 履歴・現行スキーマ・モデル定義を Glob/Grep で確認する。重複・矛盾する migration を作らない。
2. **アクター視点を1行で先に書く。** この変更で「誰のどの体験」が壊れ得るか（例: Worker の当日シフト表示、出席記録）。
3. **破壊は分離する。** スキーマ拡張と破壊（カラム削除等）を同一 migration に混ぜない（expand-contract）。
4. **rollback と backup を先に用意する。** 戻せない migration は原則作らない。

## 危険度分類（exec-boundary-guard と概念を揃える）

| 度 | 例 | 扱い |
|---|---|---|
| Green | 開発DBでの追加系 migration、nullable カラム追加、新規テーブル | 通常実行 |
| Yellow | インデックス追加、制約追加、既存 migration の期待値変更、staging へのデータ移行 | 理由/影響/リスクを1〜3行で示してから実行 |
| Red | 本番DB操作、破壊的スキーマ変更（DROP/型変更）、データ削除、大規模UPDATE/DELETE、`migrate dev reset` 等 | 毎回事前確認。backup と rollback 手順の提示が前提 |

## zero-downtime: expand-contract（3フェーズ）

1. **Expand** — 新カラム/テーブルを nullable・デフォルト無しで追加。旧コードと共存させる。
2. **Migrate / Backfill** — データを移す。大量行は batch UPDATE（一括 UPDATE で長時間ロックしない）。
3. **Contract** — 旧カラム削除・NOT NULL 化は、新コードの全デプロイ完了後の**別 migration**で行う。

破壊フェーズを前倒ししない。各フェーズの間にデプロイ完了を挟む。

## lock 回避

- 大量行の UPDATE/DELETE はバッチ分割（例: 主キー範囲やLIMITで区切る）
- インデックス追加・`ALTER TABLE` の取得ロックレベルとロック時間を、テーブルサイズから事前に見積もる
- PostgreSQL で大規模テーブルに index を追加する場合、通常の `CREATE INDEX` は長時間の書き込みロックに注意する。`CREATE INDEX CONCURRENTLY` を使う選択肢があるが、これはトランザクションブロック内で実行できない。ORM/migration ツール（Alembic 等）のトランザクション設定と生成 SQL を事前に確認してから使う

## データ整合性の確認

- backfill 後: 件数一致・想定外 NULL・重複・FK 整合をクエリで検証
- 移行前後で代表行をサンプリングして突き合わせる
- 順序依存・環境依存の値を前提にしない

## backup と staging 検証（必須）

- Red 操作の前に backup を取得（取得済みを確認）
- 本番適用前に staging（または本番相当データのコピー）で migration を通す
- rollback 手順を実際に1回試す

## フレームワーク別クイックリファレンス

### Flask / Alembic
- `flask db migrate` の autogenerate を鵜呑みにせず、生成 SQL・差分・ロック挙動を読む
- `flask db upgrade --sql`（offline mode）で適用前 SQL を目視確認する
- `CREATE INDEX CONCURRENTLY` 等のトランザクション外実行が必要な操作は、Alembic の transaction 設定（autocommit ブロック等）と実行 SQL を事前確認する。特定 API の使い方を断定せず、ロック挙動を確認してから採用する

### Django
- `makemigrations` → `migrate`。データ移行は `RunPython`（reverse も書く）
- スキーマと状態の分離は `SeparateDatabaseAndState`
- `--plan` / `sqlmigrate` で適用内容を事前確認

### Prisma
- 開発は `migrate dev`、本番は `migrate deploy`。混同しない
- `migrate dev reset` は本番厳禁（全データ消去）
- 破壊的変更は複数ステップに分割。手書き SQL migration で expand-contract を表現

### PostgreSQL（raw）
- batch UPDATE / `ALTER TABLE` のロックレベル把握 / 大規模 index 追加時のロック注意（上記 lock 回避参照）

### SQLite
- SQLite は PostgreSQL/MySQL に比べて `ALTER TABLE` の制約が強く、可能な操作はバージョンによって異なる
- DROP COLUMN / 型変更 / 制約変更を行う場合は、現在の SQLite バージョンと ORM が生成する SQL を確認する
- 必要に応じて、新テーブル作成 → データ移送 → リネームの再作成パターンを検討する
- ファイル DB の場合は、適用前に DB ファイルをコピーしてバックアップできる利点を活用する

### Google Sheets / GAS 連携がある場合
- DB の値・列構成・ステータスを Sheets に同期している場合、DB migration だけで完結しない
- GAS や同期スクリプトが列順・ヘッダ名・固定列番号を前提にしていないかを Grep で確認する
- Sheets 側は DB のようなトランザクションを持たないため、再実行可能性・冪等性・部分失敗時の復旧手順を確認する
- DB 変更と Sheets 変更のどちらを先に適用するかを明示する

## Definition of Done

- rollback 手順を書いた / backup を確認した / staging で通した
- lock 時間を見積もった / データ整合性を検証した
- 本番適用は Red として確認を得た
- 「テスト通過」だけで完了としない（migration は本番固有設定・データ量で挙動が変わる）

## アンチパターン

- expand と contract を同一 migration に混ぜる
- 一括 UPDATE で長時間ロック
- autogenerate / 生成 migration を読まずに適用
- 本番で `migrate dev reset` / 無条件 `DELETE`・`UPDATE`
- backup・rollback 無しで Red 操作に進む
- Sheets 同期層を見ずに列構成を変更
