# AI-PLC

AI-PLC は、Goal から成果物生成までを 4 Stage で進める local-first パイプライン。

## Stages

1. `01-collection/SKILL.md`
   - Goal を受け取り、Scope と Context を初期化する
2. `02-inception/SKILL.md`
   - Goal を Task と Sub-Layer に分解する
3. `03-construction/SKILL.md`
   - Task 実行用の Agent 定義を作る
4. `04-operation/SKILL.md`
   - Task を実行し、成果物と知見を反映する

## Core Principles

- local-first
- explicit sync
- context as asset
- adaptive workflow
- verification before propagation

## Required Rules

- `{{agent_home}}/rules/ai-plc-system.md`
- `{{agent_home}}/rules/ai-plc-session.md`
- `{{agent_home}}/rules/ai-plc-adaptive.md`

## Main Files

- `intent.yaml`
- `context.yaml`
- `backlog.yaml`
- `Context/`
- `Agents/`
- `Documents/`

## Naming

- `SKL_plc_*`
- `RUL_plc_*`
- `ROL_plc_*`
- `AGT_plc_*`
