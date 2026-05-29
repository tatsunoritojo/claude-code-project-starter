# Architecture Decision Records (ADR)

このディレクトリには、このプロジェクトの設計判断記録を **1判断1ファイル** で配置する。

## 命名規約

`NNNN-<kebab-title>.md`

- `NNNN`: 4桁ゼロ埋め連番（例: `0001-use-postgresql.md`）
- `<kebab-title>`: ケバブケース（小文字＋ハイフン）の短いタイトル

## ファイル形式

`~/.claude/skills/doc-init/templates/ADR.md.template` を雛形として参照すること。

```
# NNNN. <Title>

日付: YYYY-MM-DD

## Status
Accepted / Proposed / Deprecated / Superseded by NNNN

## Context
何に直面しているか / 何を最適化したいか / 制約

## Decision
何を決めたか（1-3文で明確に）

## Consequences
- ポジティブな帰結（メリット）
- ネガティブな帰結（デメリット・トレードオフ）
```

## 鉄則

- **既存ADRは原則として触らない**（追記専用＝原理的に腐敗しない）
- 古い判断を覆すときは、Status を `Deprecated` または `Superseded by NNNN` に更新するのみ。Decision/Context は変えない
- 新しい判断は新しい連番で追加する

## 参考

グローバル規約: `~/.claude/CLAUDE.md` の「プロジェクトドキュメント整備ルール」セクション
