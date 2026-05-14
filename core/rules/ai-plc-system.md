# AI-PLC System Rule

AI-PLC の全 `rules` と `skills` が前提とする共通 runtime ルール。

## 1. Purpose

- AI-PLC の完了条件は「実際に使える成果物が存在すること」。
- 実装系タスクは、設計や提案だけで完了扱いにしてはならない。
- タスク完了前に、生成物、更新対象、反映先を確認する。

## 2. Runtime Scope

- `{{agent_home}}` は実行環境ごとのローカル管理ディレクトリを指す。
- 例:
  - Claude Code: `.claude`
  - Cursor: `.cursor`
  - Codex: `.codex`
- runtime ルール本文では、環境固有パスの代わりに `{{agent_home}}` を使う。

## 3. Context Cascade

親 Scope から子 Scope へのコンテキスト伝播は次の 3 種だけを使う。

1. `global_immutable`
   - 子へ必ず継承する。
   - 子は変更してはならない。
2. `overridable`
   - 子へ継承する。
   - 子が明示的に上書きした場合のみ差し替える。
3. `local_only`
   - 子へ伝播してはならない。

運用ルール:

- `intent.yaml` には継承前提の重要条件を明示する。
- Sub-Layer 作成時は、親の `global_immutable` を自動継承する。
- `overridable` の変更は子 Scope 側で明示する。
- `local_only` は参照させてもコピーしてはならない。

## 4. Required Scope Files

各 Scope は最低限次の構成を持つ。

- `intent.yaml`
- `context.yaml`
- `backlog.yaml`
- `Context/`

必要に応じて次を持つ。

- `variables.yaml`
- `Agents/`
- `Rules/`
- `Subagents/`
- `Documents/`

運用ルール:

- `intent.yaml` は Goal、mode、workflow_depth、owner、deadline、親子関係を保持する。
- `context.yaml` は `Context/` の索引として使う。
- `backlog.yaml` はタスク正本として使う。
- `Documents/` は成果物の格納先として使う。

## 5. Naming

命名は次を使う。

- `SKL_plc_*` : 実行スキル
- `RUL_plc_*` : 自動適用ルール
- `ROL_plc_*` : 視点テンプレート
- `AGT_plc_*` : Agent 定義

旧名称を新規記述に混在させてはならない。

- `layer.yaml` ではなく `intent.yaml`
- `tasks.yaml` ではなく `backlog.yaml`
- `Commands/` ではなく `Agents/`

## 6. Mob Checkpoint

全スキルで次を守る。

1. Mob Checkpoint では必ず人間の応答を待つ。
2. 応答があるまで次の Phase に進んではならない。
3. 最低限、`OK` / `修正` / `差し戻し` の応答を受けられる形で止まる。
4. 「確認なしスキップ」をしてはならない。

## 7. Persistent Memory

永続記憶は次を正本として扱う。

- `{{agent_home}}/soul.md`
- `{{agent_home}}/user.md`
- `{{agent_home}}/memory.md`

読み取りルール:

- セッション開始時に関連部分を参照する。
- スキル実行時に、判断に必要な既存知見があれば参照する。

書き込みルール:

- 再利用価値のある知見だけを `memory.md` に追記する。
- ユーザー固有の判断傾向だけを `user.md` に追記する。
- 重複エントリを増やしてはならない。

## 8. Post-Deliver Propagation

`SKL_plc_04_operation` の Phase 7 では、次を必ず確認して結果を出力する。

1. `backlog.yaml` 更新
2. `context.yaml` 更新
3. `memory.md` 確認
4. `user.md` 確認
5. `sync_targets` 確認
6. wiki 波及更新確認
7. `log.md` 確認
8. Project Registry 更新可否確認

運用ルール:

- 確認せずにスキップしてはならない。
- 「該当なし」と判断した場合だけスキップできる。
- Propagation は Verification 完了後にしか実行してはならない。

## 9. External Sync

外部同期は `intent.yaml` の `sync_targets` が明示された場合のみ有効。

原則:

- 既定値は `sync_targets: []`
- ローカルの `backlog.yaml` を正本とする
- 同期先を自動推測してはならない

External Sync で最低限含める情報:

- `title`
- `description`
- `context`
- `related_docs`
- `constraints`
- `acceptance_criteria`

同期の役割は 2 つに限定する。

1. タスク委譲
2. ステータス同期

## 10. Knowledge Hygiene

wiki 運用では次を守る。

- 新しい知見に再利用価値がある場合のみ波及更新する。
- 既存知見と矛盾する場合は削除せず `CONTRADICTION` として保持する。
- 月次または手動で Knowledge Lint を実行できる状態を保つ。

## 11. Verification Baseline

全成果物は workflow depth に応じて次を実行する。

1. `L1`
   - 単体妥当性の確認
2. `L2`
   - 全体整合性の確認
3. `L3`
   - 受け手価値の確認

適用ルール:

- `simple` は `L1`
- `standard` は `L1 + L2`
- `complex` は `L1 + L2 + L3`

## 12. Universal NFR

Complex 寄りの成果物では、必要に応じて次も確認する。

- performance
- security
- accessibility
- reusability

## 13. Extension Opt-in

追加チェックは `intent.yaml` の `extensions` で有効化する。

例:

- `legal`
- `brand`
- `privacy`
- `security`
- `testing`

宣言されていない Extension を暗黙適用してはならない。

## 14. Execution Priorities

判断優先順位は次の通り。

1. ユーザーの明示指示
2. この `RUL_plc_system`
3. `RUL_plc_session`
4. `RUL_plc_adaptive`
5. 各 `SKILL.md` の個別指示
6. ローカル Context

個別スキルの記述が本ルールと矛盾する場合は、本ルールを優先する。
