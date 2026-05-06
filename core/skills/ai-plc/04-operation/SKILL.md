---
name: 04-operation
description: Execute AI-PLC tasks with generated Agents, produce artifacts, run verification, and propagate updates to backlog, context, and related knowledge stores. Use when a task is ready to run after planning and agent generation.
compatibility: Works in local agent environments that can read and write workspace files. Some tasks may optionally require external tools or network access.
metadata:
  stage: "4"
  system: "ai-plc"
  kind: "skill"
---

# SKL_plc_04_operation

Stage 4. Agent 定義に従って task を実行し、成果物と知見を反映する。

## Required Context

- `core/skills/ai-plc/README.md`
- `core/rules/ai-plc-system.md`
- `core/rules/ai-plc-session.md`
- `core/rules/ai-plc-adaptive.md`

## Inputs

- `backlog.yaml`
- `Agents/`
- `Context/`
- `target_task` optional

## Outputs

- `Documents/`
- `Context/` updates
- `context.yaml` updates
- `backlog.yaml` updates
- Production Skill optional

## Runtime Flow

1. 実行可能 task を特定する
2. Mob Checkpoint で対象 task を選ぶ
3. task 実行前に追加 Context を収集する
4. Agent 定義に従って task を実行する
5. 成果物を保存する
6. Phase 5.5 で Verification を実行する
7. 必要なら Backtrack Trigger を判定する
8. Phase 6 で status と manifest を更新する
9. Phase 7 で Propagation を実行する
10. まだ task が残るなら次 task を案内する
11. `platform_builder` かつ全完了時だけ Production Skill を生成する

## Verification

`workflow_depth` に応じて次を実行する。

- `simple`: `L1`
- `standard`: `L1 + L2`
- `complex`: `L1 + L2 + L3`

Verification を完了するまで Phase 6 へ進めない。

## Propagation

Phase 7 では次を必ず確認し、結果を明示する。

1. `backlog.yaml`
2. `context.yaml`
3. `memory.md`
4. `user.md`
5. External Sync
6. wiki
7. `log.md`
8. Project Registry

## Backtrack

`RUL_plc_adaptive` の BT ルールに従う。

- 提案のみ
- 自動実行禁止
- 理由を残す

## Required Behavior

- 実装系 task は設計だけで完了にしない
- Mob Checkpoint では必ず停止する
- task 指定があっても Verification と Propagation は省略しない
- Next Action は `RUL_plc_session` に従って返す

## Must Not

- 実行前 Context 収集を完全に飛ばさない
- 検証前に完了扱いしない
- Propagation を確認なしでスキップしない
- ユーザー承認なしに backtrack しない
