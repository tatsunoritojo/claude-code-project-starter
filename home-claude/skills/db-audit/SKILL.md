---
name: db-audit
description: DB 設計レビューを「制約・運用・観測」中心の構造化テンプレートで実施する。全テーブル audit / 特定サブシステム audit のいずれにも対応。「DB レビュー」「データベース層を分析」「テーブル設計を見て」「<サブシステム名> のデータが正しく扱われているか」「スキーマ整合性チェック」等のトリガー、または ER 図中心の浅いレポートに陥りそうなときに発火。
allowed-tools: Read, Glob, Grep, Bash(git:*), Bash(grep:*), Bash(flask:*), Bash(python:*)
model: sonnet
---

# DB Audit

DB 層レビューの構造化ワークフロー。グローバル CLAUDE.md「コードベース検証時の視点」を実行手順に落とし込んだもの。プロジェクトの CLAUDE.md / memory に DB 設計方針が記載されていれば、それも参照する。

ER 図中心の「現状把握レポート」では、スキーマ整合性の担保方式・運用上のリスク・観測性の欠落といった**根の問題が露呈しない**。本スキルはそれを構造化された 8 セクション成果物で補う。

## 起動条件

- 「DB レビューして」「データベース層を分析」「テーブル設計を見て」
- 「<サブシステム名> (例: Worker 提出 / vacancy / 認証) のデータが正しく扱われているか」
- 「スキーマ整合性チェック」「DB 監査」「データモデル評価」
- 障害対応中に schema mismatch / UndefinedColumn / UndefinedTable が出たとき
- ER 図中心の浅いレポートを書きそうなとき

## 非起動条件

- 単発の SQL チューニング相談 (1 クエリの EXPLAIN 等)
- migration の作成だけが目的のとき (alembic コマンド実行)
- アプリ層のロジックレビュー (DB に触れないコード変更)

## 出力フォーマット（8 セクション固定）

毎回以下の 8 セクションを出す。範囲が「特定サブシステム」のときも同じ章立てで、対象テーブル数を絞って実施する。

### 0. 対象範囲

- 中核テーブル (PK で一意に識別される実体)
- 周辺テーブル (FK 等で依存する実体)
- 主要コードパス (書込み・読込み・状態変更の入口)

### 1. 制約マトリクス

各テーブルについて以下を表形式で出す:

| 列 | 型 | NN | UQ | FK (on delete) | CK 候補 | Index |

- **NN**: NOT NULL かどうか
- **UQ**: UNIQUE 制約 (PK, 単独 UQ, 複合 UQ どれか)
- **FK (on delete)**: migrations の `ondelete=` を**実検証**する。指定無しなら NA (Postgres デフォルト = NO ACTION = 実質 RESTRICT)
- **CK 候補**: `status IN (...)`、`start_time HH:MM 形式`、`len(text) <= N` 等 — DB に CHECK が無いがアプリ層で検証している事項
- **Index**: 単純 PK / UQ 由来、複合 index、不足

### 2. 削除セマンティクス

ORM cascade と DB ON DELETE は別レイヤなので、必ず分離して書く:

```
relation                ORM cascade   DB FK on delete   nullable   実効挙動                 業務上の推奨操作
─────────────────────────────────────────────────────────────────────────────────────────────────────
A → B                   cascade        NO ACTION         不可       ORM 経由なら子削除→親削除  物理削除可
A → C                   なし           NO ACTION         不可       親削除は IntegrityError    soft delete のみ
A → 履歴系               なし           NO ACTION         NULL可     親削除は失敗               削除禁止 / 匿名化
```

「業務上の推奨操作」列は必ず付ける。FK が守ってくれることに頼らず、**業務として削除を許すかどうか**を明文化する。

### 3. 状態遷移 / 整合性リスク

- `status` 等の文字列 enum 列について、許可遷移を図 or 表で示す
- DB に CHECK 制約が無く、アプリ層だけで遷移制御している場合は明示
- **dead state** (コードでは参照されているが書込みされない) を発見したらマーク
- 「整合性リスク」: status と他列の論理矛盾になりうる組合せ (例: `submitted` だが `submitted_at` NULL)

### 4. 並行性 / Transaction 境界

- 主要書込み経路の transaction 範囲を明示 (`db.session.commit()` 位置、対応する SELECT 〜 commit のスパン)
- **行ロック (`FOR UPDATE`) の有無** を確認
- Race condition シナリオを最低 1 件書く (例: 「同一 user × period への同時 POST」「2 candidate の同時 accept」)
- Lost update / Dirty read のリスクを評価
- 楽観ロック (`expected_version`) や UQ 制約による救済が効くかを判定

### 5. 観測性不足

監視・ログ・アラートの欠落を列挙:

| 観測対象 | 状態 | 改善案 |
|---|---|---|
| 提出失敗 (4xx) | ❌ 専用ログ無し | 構造化ログ追加 |
| 提出成功カウント | ❌ メトリクス無し | StatsD / Sentry breadcrumb |
| Race condition (IntegrityError) | ❌ 検知できない | catch して log + 409 変換 |
| Schema revision drift | ❌ alembic_version 監視無し | /health/schema cron polling |

### 6. Integrity Check 用 SQL（実証）

production DB に対して NOT EXISTS / 範囲 / 論理整合性チェックを実行し、結果を表形式で:

```sql
-- orphan check (NOT IN ではなく NOT EXISTS で NULL 安全に)
SELECT COUNT(*) FROM child c
WHERE NOT EXISTS (SELECT 1 FROM parent p WHERE p.id = c.parent_id);

-- range check
SELECT COUNT(*) FROM slots s JOIN periods p ON p.id = s.period_id
WHERE s.slot_date < p.start_date OR s.slot_date > p.end_date;

-- logical consistency
SELECT COUNT(*) FROM submissions
WHERE status='submitted' AND submitted_at IS NULL;
```

最低 8〜10 項目チェックして、結果が 0 件であることを確認 (1 件でも出たら該当データを抽出して原因分析)。

### 7. 「適切に扱えているか」の総合評価

- ✅ 強み (現状で機能している部分)
- ⚠ 弱点 (改善余地、重要度付き)
- 評価ランク (A〜D で 4 観点: データ完全性 / 業務正確性 / 観測性 / 拡張性)

### 8. P0 / P1 / P2 推奨アクション

| 優先度 | 項目 | 理由 |
|---|---|---|
| **P0** (即時) | 業務影響あり / 整合性破綻寸前 | – |
| **P1** (次スプリント) | 観測性向上 / Race 対策 / 不足 index | – |
| **P2** (中期) | retention / cascade 緩和 / non-normalized 列 | – |
| **P3** (要仕様議論) | dead status の扱い / RLS 検討 等 | – |

## 実行手順

### Step 1: スコープ確定
ユーザーから「全テーブル」「特定サブシステム」「特定 API」のどれかを引き出す。曖昧なら聞く。

### Step 2: 対象テーブルとコードパスの収集
- `app/models/*.py` を Glob で列挙、対象を Read
- `migrations/versions/*.py` を確認 (ondelete= の有無を必ず実検証)
- `app/services/*.py` / `app/blueprints/*.py` の主要書込み経路を Grep + Read

### Step 3: 8 セクションを順番に埋める
セクション 0 → 8 の順で書く。途中で省略しない。データが取れない箇所は「実証未実施」「要追加調査」と明記。

### Step 4: Integrity Check 用 SQL の実行
production DB に対して `flask shell` または直接 Python スクリプトで実行:

```bash
FLASK_APP=wsgi.py FLASK_ENV=development \
  DATABASE_URL=$(grep "^DATABASE_URL_UNPOOLED=" .env.local | cut -d= -f2- | tr -d '"') \
  python -c "..."
```

NOT IN ではなく **NOT EXISTS** を使う (NULL 安全)。

### Step 5: 推奨アクションの優先度付け
P0/P1/P2/P3 で振り分け、特に P0 がある場合は本文の冒頭で警告する。

## 重要原則

1. **ORM 宣言と DB 実 DDL は別レイヤ** — cascade='all, delete-orphan' (ORM) と ON DELETE CASCADE (DB) は責務が異なる。両者を分離して書く
2. **migrations の `ondelete=` を実検証** — 推測で「FK で守られている」と書かない。grep で実定義を確認
3. **NOT IN を避ける** — NULL 安全な NOT EXISTS で書く
4. **業務語彙を併記** — テーブル設計を語るときも「Worker / Admin / 候補者がどう影響するか」を必ず書く (アクター視点)
5. **「制約・運用・観測」中心、ER は補助** — ER 図は対象範囲が初出のときだけ。本文は制約と運用と観測

## 既存スキル / 設計方針との関係

- **プロジェクトの CLAUDE.md / memory**: DB 設計方針（ORM/DB 分離、観測性優先などの原則）が記載されていれば本スキルの前提として参照する
- **incident-response スキル**: schema mismatch 障害時に併用。本スキルで根本原因を構造化、incident-response で復旧手順を構造化

## 補足

特定サブシステムの audit では、まず ER 中心の現状把握から入りがちだが、制約・運用・観測中心に書き直し、ORM/DB 分離・rollback / retention の観点を加えると深度が出る。範囲が広い場合は中核テーブル群と特定サブシステムを分けて段階的に実施する。
