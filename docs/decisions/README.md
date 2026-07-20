# Architecture Decision Records (ADR)

このリポジトリの設計判断記録を **1判断1ファイル** で配置する。

## Index

- [`0001-distribute-as-anonymized-style-pack.md`](0001-distribute-as-anonymized-style-pack.md)
- [`0002-package-reliable-ship-as-a-plugin.md`](0002-package-reliable-ship-as-a-plugin.md)

## 命名規約

`NNNN-<kebab-title>.md`（`NNNN` は4桁ゼロ埋め連番）

## 形式

`## Status` / `## Context` / `## Decision` / `## Consequences`

## 鉄則

- **既存ADRは原則として触らない**（追記専用＝原理的に腐敗しない）
- 古い判断を覆すときは Status を `Deprecated` / `Superseded by NNNN` に更新するのみ
