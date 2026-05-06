# AI-PLC Refactoring Policy

## 目的

`core/rules` と `core/skills` を、AI が実行時に読む runtime 文書として維持し、人向け説明は `docs/` に分離する。

## 原則

1. `core/rules`
   - 共通制約だけを書く
   - MUST / MUST NOT に相当する内容を優先する
   - 背景説明、歴史、移行事情は書かない
2. `core/skills`
   - stage 固有の flow、inputs、outputs、停止点だけを書く
   - 共通ルールは `core/rules` へ寄せる
   - 同じ説明を複数 skill に重複させない
3. `docs`
   - 設計思想
   - 用語集
   - 旧体系との比較
   - 例、図、導入ガイド

## 書き分け基準

`core/` に残すもの:

- 実行順序
- 必須ファイル
- 入出力
- 停止条件
- 禁止事項
- 検証条件

`docs/` に逃がすもの:

- なぜそう設計したか
- どのツールに対応するかの背景
- 旧名称との長い比較
- 大きな図
- 詳細なチュートリアル

## 推奨テンプレート

`rule`:

1. Purpose
2. Scope
3. Required Behavior
4. Must Not

`skill`:

1. Required Context
2. Inputs
3. Outputs
4. Runtime Flow
5. Required Behavior
6. Mob Checkpoint
7. Must Not

## レビュー観点

- 同じ内容が 2 か所以上に書かれていないか
- runtime 文書だけ読めば実行判断できるか
- 人向け説明を抜いても意味が落ちていないか
- 逆に docs に逃がした説明が runtime に戻っていないか
