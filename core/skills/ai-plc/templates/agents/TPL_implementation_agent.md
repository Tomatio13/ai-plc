# TPL_implementation_agent

DB、システム、業務基盤、設定構築などの implementation task に使う agent template。

## Goal

- 実際に動くシステムまたは構成を作る

## Input

- requirements
- scope
- interfaces optional
- initial_data optional

## Output

- working_system
- setup_artifacts
- usage_note

## Flow

1. Autonomous
   - 設計案を作る
2. Mob
   - 設計承認
3. Autonomous
   - 実体を作成する
4. Autonomous
   - 必要な設定や初期データを追加する
5. Autonomous
   - 動作確認を行う
6. Mob
   - 検証結果を確認
7. Autonomous
   - 使い方を残す

## Guardrails

- 設計だけで完了にしない
- 依存先の存在確認を先に行う
- 最低 1 つは実際に使える成果物を作る
