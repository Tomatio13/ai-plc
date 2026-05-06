---
name: 02-inception
description: Decompose a goal into executable tasks and sub-layers, then generate backlog.yaml for AI-PLC. Use when collection is complete and you need a concrete plan, task graph, or delegation structure before execution.
compatibility: Works in local agent environments that can read and write workspace files. May optionally use external research during decomposition.
metadata:
  stage: "2"
  system: "ai-plc"
  kind: "skill"
---

# SKL_plc_02_inception

Stage 2. Goal を Task と Sub-Layer に分解し、実行可能な backlog を作る。

## Required Context

- `core/skills/ai-plc/README.md`
- `core/rules/ai-plc-system.md`
- `core/rules/ai-plc-session.md`
- `core/rules/ai-plc-adaptive.md`
- `core/skills/ai-plc/templates/`

## Inputs

- `intent.yaml`
- `context.yaml`
- `Context/`
- `decomposition_strategy` optional

## Outputs

- `backlog.yaml`
- `sublayers/` optional
- `Documents/` optional

## Runtime Flow

1. `intent.yaml` と `Context/` を読む
2. 不足があれば追加調査する
3. 分解戦略を選ぶ
   - product_manager
   - system_architect
   - content_strategist
   - tech_lead
   - generic
4. Goal を次の 2 種に分ける
   - Sub-Layer
   - Task
5. Mob Checkpoint で分解案の承認を取る
6. `backlog.yaml` を生成する
7. 必要なら `sublayers/` を初期化する
8. 外部委譲候補があれば External Sync 候補として示す
9. Mob Checkpoint で次 Stage を提案する

## Required Behavior

- Task は 1 から 2 日で完結する粒度を目安にする
- Sub-Layer は独自 Context が必要な場合だけ作る
- backlog の各 task には type、status、依存関係、優先度を持たせる
- `workflow_depth=standard` 以上では Stage 3 を前提に構造化する
- External Sync は承認前に自動実行しない

## Mob Checkpoint

必須停止点は 2 つ。

1. 分解承認
2. 次 Stage 提案

各停止点で `RUL_plc_session` の出力契約を守る。

## Must Not

- 分解承認なしで backlog を確定しない
- backlog を作らずに Stage 3 へ進めない
- 外部委譲を暗黙で push しない
