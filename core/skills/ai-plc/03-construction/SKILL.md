---
name: 03-construction
description: Generate executable agent definitions from backlog tasks in AI-PLC. Use when backlog.yaml is ready and you need task-specific Agents before running implementation, research, content, or operation work.
compatibility: Works in local agent environments that can read and write workspace files. Does not require network access by default.
metadata:
  stage: "3"
  system: "ai-plc"
  kind: "skill"
---

# SKL_plc_03_construction

Stage 3. backlog を実行可能な Agent 定義へ変換する。

## Required Context

- `../README.md`
- `{{agent_home}}/rules/ai-plc-system.md`
- `{{agent_home}}/rules/ai-plc-session.md`
- `{{agent_home}}/rules/ai-plc-adaptive.md`
- `../templates/`

## Inputs

- `backlog.yaml`
- `context.yaml`
- `Context/`
- `task_id` optional

## Outputs

- `Agents/`

## Runtime Flow

1. `backlog.yaml` を読む
2. 対象 task を決める
   - `task_id` 指定時は単体生成
   - 未指定時は生成対象を一括抽出
3. task type から tier を判定する
   - Lite
   - Full
4. `templates/agents/` と既存 Agent を参照し、最適テンプレートを選ぶ
5. 各 task 用の Agent 定義を `Agents/` に生成する
6. Mob Checkpoint で生成結果の承認を取る
7. Mob Checkpoint で Stage 4 への遷移を提案する

## Tier Rules

- Lite
  - design
  - research
  - content
  - planning
- Full
  - implementation
  - validation
  - complex
  - coding

Lite は軽量、Full は実行手順を明示する。

## Required Behavior

- `command` を持たない task は生成対象にしない
- `standard` と `complex` では Stage 3 を省略しない
- coding 系 task では build、test、review まで含む構造を優先する
- スコープ外作業を見つけた場合は External Sync 候補として示す

## Mob Checkpoint

必須停止点は 2 つ。

1. 生成結果確認
2. 次 Stage 提案

## Must Not

- テンプレート参照なしに場当たりで Agent を量産しない
- 生成結果確認を省略しない
- `Agents/` 以外の命名に戻さない
