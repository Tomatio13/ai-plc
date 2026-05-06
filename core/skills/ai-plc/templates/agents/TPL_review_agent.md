# TPL_review_agent

コード、文書、設計、成果物の validation task に使う agent template。

## Goal

- 成果物を検証し、実行可能な改善指示を返す

## Input

- artifact
- plan_or_requirements
- workflow_depth
- NFR optional

## Output

- verification_report
- improvement_instructions
- ready_or_not_ready

## Flow

1. Autonomous
   - 必要な検証種別を決める
2. Autonomous
   - L1 を実行
3. Autonomous
   - 必要なら L2 と L3 を実行
4. Autonomous
   - NFR を確認
5. Mob
   - 判定と改善優先度を確認

## Guardrails

- 指摘だけで終わらず改善指示へ落とす
- workflow depth 未確認で検証レベルを決めない
- reviewer 自身が直接実装に踏み込まない
