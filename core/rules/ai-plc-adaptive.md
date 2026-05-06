# AI-PLC Adaptive Rule

AI-PLC の workflow depth、mode、focus role、next action、backtrack を定義する runtime ルール。
背景説明は [docs/AI-PLC-CORE-OVERVIEW.md](../../docs/AI-PLC-CORE-OVERVIEW.md) を参照する。

## 1. Workflow Depth

`SKL_plc_01_collection` は Goal を分析し、`workflow_depth` を次の 3 値から決める。

1. `simple`
   - 単一タスク
   - 明確なゴール
   - 既知パターン
   - 1 から 2 日以内
2. `standard`
   - 複数タスク
   - タスク分解が必要
   - Sub-Layer は不要
3. `complex`
   - 再帰的分解が必要
   - Sub-Layer が必要
   - 検証と連携の負荷が高い

適用ルール:

- `simple` は Stage 1 から Stage 4 へ短縮可能
- `standard` は Stage 1 から 4 を順次実行
- `complex` は Stage 1 から 4 に加えて Sub-Layer 再帰を許可

## 2. Verification Mapping

workflow depth と検証レベルの対応は固定する。

- `simple` -> `L1`
- `standard` -> `L1 + L2`
- `complex` -> `L1 + L2 + L3`

## 3. Mode

Goal の性質から mode を決める。

- `direct`
  - 一度きりの成果物を作る
- `platform_builder`
  - 繰り返し実行する仕組み自体を作る

`platform_builder` では Stage 4 完了後に Production Skill 生成を許可する。

## 4. Focus Role

Goal の性質から Role を選ぶ。

- product development -> `ROL_plc_product_manager`
- system design -> `ROL_plc_system_architect`
- content creation -> `ROL_plc_content_strategist`
- coding and implementation -> `ROL_plc_tech_lead` or `ROL_plc_developer`
- other -> `ROL_plc_generic`

## 5. Next Action

各 Stage 完了後の既定遷移は次の通り。

1. Stage 1 完了 -> Stage 2
2. Stage 2 完了 -> Stage 3
3. Stage 3 完了 -> Stage 4
4. Stage 4 タスク完了かつ残タスクあり -> Stage 4 継続
5. Stage 4 全完了かつ `direct` -> 終了
6. Stage 4 全完了かつ `platform_builder` -> Production Skill へ進行

Next Action は `RUL_plc_session` の Completion Output Contract に従って出力する。

## 6. Backtrack Triggers

次のトリガーを監視する。

1. `BT-1`
   - L1 または L2 で critical failure
   - 提案先: Re-Inception
2. `BT-2`
   - L3 に必要な検証が不足
   - 提案先: Re-Inception
3. `BT-3`
   - マイルストーン到達時に残タスク再評価が必要
   - 提案先: Re-Inception
4. `BT-4`
   - Goal drift
   - 提案先: Re-Collection
5. `BT-5`
   - 外部依存不足
   - 提案先: backlog 追加
6. `BT-6`
   - 設計前提の破綻
   - 提案先: Re-Inception
7. `BT-7`
   - backlog 完了後に Goal gap が残る
   - 提案先: Re-Collection
8. `BT-8`
   - Conditional Go 判定
   - 提案先: Re-Inception
9. `BT-9`
   - ユーザーによる進捗訂正
   - 提案先: 軽量 Re-Inception
10. `BT-10`
   - 会話中の新事実
   - 提案先: Re-Collection または Re-Inception

## 7. Backtrack Rules

- backtrack は提案のみ行う。
- ユーザー承認なしに実行してはならない。
- 該当しない場合は選択肢を増やしてはならない。
- backtrack 理由は `backlog.yaml` の `refactoring_log` に残す。

## 8. Stage 3 Requirement

`workflow_depth` が `standard` または `complex` の場合、Stage 3 は必須。

禁止事項:

- Stage 2 完了後に Stage 4 直行を推奨すること
- 「Backlog があるから十分」という理由で Stage 3 を省略すること

`simple` の場合だけ Stage 3 省略を許可する。
