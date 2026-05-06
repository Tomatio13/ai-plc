# TPL_task_patterns

Stage 3 が task 種別から agent template を選ぶための meta template。

## Task Types

- `research` -> `TPL_research_agent`
- `implementation` -> `TPL_implementation_agent`
- `content` -> `TPL_content_agent`
- `operation` -> `TPL_operation_agent`
- `validation` -> `TPL_review_agent`
- `planning` -> `TPL_research_agent`
- `coding` -> `TPL_coding_agent`

## Shared Rules

1. 人間が Mob Checkpoint で明示した情報を最優先する
2. 出力は入力の規模と範囲に対応していなければならない
3. implementation と coding は「動く成果物」が完了条件
4. すべての agent flow に検証ステップを含める

## Verification Mapping

- `simple` -> `L1`
- `standard` -> `L1 + L2`
- `complex` -> `L1 + L2 + L3`

## Flow Patterns

- Standard
  - Autonomous -> Mob -> Autonomous -> Mob
- Implementation
  - Design -> Mob -> Build -> Verify -> Mob
- Operation
  - Variables -> Mob -> Runtime -> Eval -> Loop

## Guardrails

- task type が曖昧なら generic に逃がさず再判定する
- 検証なしの agent template を作らない
