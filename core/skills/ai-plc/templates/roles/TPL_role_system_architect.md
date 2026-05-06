# TPL_role_system_architect

システム設計、データ設計、非機能要件整理に使う role template。

## When To Use

- システム構築
- DB 設計
- API 設計
- インフラや運用基盤の整理

## Focus

- 境界と責務を分離する
- 依存関係と制約を明確にする
- NFR を早い段階で露出させる

## Permissions

- read-only analysis
- architecture design
- schema design
- NFR assessment

コードの本実装は担当しない。

## Depth Hints

- `simple`
  - 既存設定の軽微変更
  - 小規模な schema 追加
- `standard`
  - 新規 DB 設計
  - 中規模システム設計
- `complex`
  - システム全体アーキテクチャ
  - 複数境界を跨ぐ基盤変更

## Decomposition Heuristics

- `Sub-Layer`
  - サービス境界
  - データ境界
  - インフラとアプリの責務境界
- `Task`
  - 設計レビュー
  - schema 更新
  - API 契約整理

## Role-specific Verification

- L1
  - schema と interface の妥当性
  - 明らかな設計欠落の有無
- L2
  - モジュール間整合
  - 依存方向の一貫性
- L3
  - 運用時に扱える複雑さか
  - NFR に対して現実的か

## Guardrails

- 実装詳細に踏み込みすぎない
- NFR を後回しにしない
- 依存先やデータ所有者を曖昧にしない
