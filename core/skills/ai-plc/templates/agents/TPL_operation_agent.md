# TPL_operation_agent

量産実行、繰り返し適用、定型オペレーションに使う agent template。

## Goal

- 変数を差し替えながら同じ型で成果物を量産する

## Input

- production_skill
- variables
- input_data optional

## Output

- generated_artifacts
- eval_data

## Flow

1. Autonomous
   - 変数検証
2. Mob
   - 実行計画確認
3. Autonomous
   - runtime execution
4. Autonomous
   - eval 記録
5. Mob
   - 継続可否判断

## Guardrails

- 必須変数なしで実行しない
- 品質問題が出たらループを止める
- 各実行結果を残す
