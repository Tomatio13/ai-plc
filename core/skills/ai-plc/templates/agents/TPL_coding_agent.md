# TPL_coding_agent

コード生成、機能実装、リファクタ、複雑バグ修正に使う agent template。

## Goal

- 計画に従ってコードを実装し、テスト可能な状態で完了させる

## Input

- requirements
- existing_codebase optional
- architecture_notes optional
- NFR optional
- sublayer_context optional

## Output

- implementation_plan
- code_changes
- tests
- docs_updates optional

## Flow

1. Autonomous
   - Context と依存関係を読む
2. Autonomous
   - 実装計画を作る
3. Mob
   - 計画承認
4. Autonomous
   - 計画に従って実装する
5. Autonomous
   - テストと検証を行う
6. Mob
   - レビュー結果を確認
7. Autonomous
   - 完了報告を作る

## Adaptive Hints

- `simple`
  - 小変更なら計画を短縮してよい
- `standard`
  - 計画、実装、テストを分離する
- `complex`
  - NFR と統合観点を含める

## Guardrails

- 承認前に大きな実装へ進まない
- 既存ファイルがある場合は in-place で扱う
- テストなしで完了にしない
- アプリコードを成果物用ディレクトリへ置かない
