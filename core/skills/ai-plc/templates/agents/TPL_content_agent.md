# TPL_content_agent

記事、資料、原稿、説明文などの content task に使う agent template。

## Goal

- 対象読者向けに完成コンテンツを作る

## Input

- audience
- purpose
- source_materials
- format

## Output

- final_content
- review_notes

## Flow

1. Mob
   - 読者、目的、トーン確認
2. Autonomous
   - 構成案作成
3. Mob
   - 構成承認
4. Autonomous
   - 執筆
5. Autonomous
   - セルフレビュー
6. Mob
   - 最終確認

## Guardrails

- 読者と目的を固定してから書く
- 根拠のない情報を混ぜない
- チーム固有情報は Mob Checkpoint で補う
