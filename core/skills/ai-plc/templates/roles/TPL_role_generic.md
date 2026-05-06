# TPL_role_generic

他ロールに明確に当てはまらない Goal に使う default role template。

## When To Use

- 未知ドメイン
- 複合的な依頼
- 初期情報が薄い依頼

## Focus

- Context から自然な分解軸を選ぶ
- 複雑化しすぎない
- 必要なら専門 role へ切り替える

## Permissions

- read
- planning
- documentation

実装権限は Goal に応じて個別判断する。

## Depth Hints

- `simple`
  - 即実行可能な単純作業
- `standard`
  - 複数ステップが必要
- `complex`
  - 未知領域
  - 分解軸が複数ある

## Decomposition Heuristics

- 時系列
- 機能単位
- 組織単位
- 技術単位

## Role-specific Verification

- L1
  - 完全性
  - 正確性
- L2
  - 論理一貫性
- L3
  - 受け手価値

## Guardrails

- generic のまま無理に押し切らない
- 依頼の性質が明確になったら専門 role を選び直す
- 不要な Sub-Layer を増やさない
