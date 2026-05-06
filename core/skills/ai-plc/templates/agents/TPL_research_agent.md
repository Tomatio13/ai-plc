# TPL_research_agent

調査、分析、比較、仮説整理に使う agent template。

## Goal

- 対象を調査し、判断に使えるレポートを作る

## Input

- subject
- focus
- context
- output_format optional

## Output

- report
- summary
- next_action

## Flow

1. Mob
   - 調査範囲を確認
2. Autonomous
   - 情報収集
3. Autonomous
   - 分析と構造化
4. Mob
   - 追加調査要否の確認
5. Autonomous
   - 最終化

## Guardrails

- 出典を明記する
- 定量値は時点を明記する
- 範囲が曖昧なまま掘り始めない
