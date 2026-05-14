# AI-PLC Session Rule

AI-PLC のセッション分割、引き継ぎ、完了報告、Mob Checkpoint 出力を定義する runtime ルール。

## 1. Split Triggers

次のいずれかに該当したら、セッション分割を検討する。

- Sub-Layer が 3 つ以上
- 総タスク数が 10 以上
- 見積が 2 時間超
- 階層深さが 3 以上

## 2. Split Strategy

分割は次の順で優先する。

1. Sub-Layer ごとに分割
2. Stage ごとに分割

緊密に依存する連続作業は同一セッションに残してよい。

## 3. Required Handoff Context

新しいスレッドには最低限次を渡す。

- `{{agent_home}}/skills/ai-plc/README.md`
- `RUL_plc_system`
- 対象 Scope の `intent.yaml`
- 対象 Scope の `context.yaml`

Sub-Layer の場合は追加で次を渡す。

- 親 Scope の `intent.yaml`
- 親 Scope の `backlog.yaml`

## 4. Parent Report

子スレッド完了時は親へ次を返す。

- Layer
- Status
- 完了数
- 主成果物
- blocker
- 学び
- 次アクション

## 5. End-of-Session Check

セッション終了前に必ず次を確認する。

1. 未着手の Sub-Layer がないか
2. 実行可能な sibling Sub-Layer がないか
3. 実行可能な pending Task がないか
4. 次 Stage で先行着手できる作業がないか

ユーザーに探索を丸投げして終了してはならない。

## 6. Reinit Rule

再初期化では次を守る。

1. トップレベルから始める
2. Sub-Layer 作業は backlog に分解してから進める
3. 1 階層ずつ確認する
4. 既存成果物を不用意に上書きしない

## 7. Completion Output Contract

Stage または Task の完了報告では、次の 4 パートを必ず出す。

1. 現在位置
2. 完了サマリ
3. 進捗ダッシュボード
4. Next Action Protocol

### 7.1 Current Position

開始時または完了時は、現在位置を明示する。

書式:

`[Scope ID] > Stage X > [Task ID or Stage] > Phase Y`

### 7.2 Completion Summary

最低限含める項目:

- Scope
- 完了対象
- 成果物
- ステータス

### 7.3 Progress Dashboard

Backlog 全体の進捗を毎回示す。

最低限含める項目:

- 完了数
- 完了率
- 実行可能 Task
- 依存待ち Task

### 7.4 Next Action Protocol

Next Action は次の 3 パートで出す。

1. 選択肢
2. 推奨理由
3. コピペ用プロンプト

ルール:

- 推奨選択肢を明示する。
- 代替選択肢も出す。
- ユーザーが選択肢を選んでも即実行してはならない。
- 実行の代わりにコピペ用プロンプトを返す。

## 8. Phase Transition Notice

Autonomous Phase を含め、Phase 完了ごとに短い遷移通知を出す。

通知に含めるもの:

- 現在位置
- 何が完了したか
- 次に進む Phase

Mob Checkpoint の場合は通知後に停止する。

## 9. Mob Checkpoint Output

Mob Checkpoint では次を守る。

1. 承認または選択ブロックを冒頭に置く
2. 出力は基本 Markdown だけで構成する
3. 応答例を明示する
4. 選んだ後に何が起きるかを明示する

最低限の応答例:

- `OK`
- `修正: ...`
- `差し戻し`

## 10. Conversational Backtrack

通常会話中でも次を検知したら、軽量な backtrack 提案をしてよい。

- 進捗訂正
- 新事実の発見
- 検証不足の露出

ただし提案だけに留め、自動実行してはならない。
