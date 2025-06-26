---
mode: agent
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runNotebooks', 'runTasks', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI']
---

プルリクエストを作成するための変更内容を取りまとめて下さい。

1. 今チェックアウトしているブランチを調べて下さい。
2. origin/mainブランチと今チェックアウトしているブランチの差分を確認して下さい。
3. どのような変更が行われたか、その変更がどのファイルに及んでいるかをまとめて下さい。(まとめ例は下記に表示)

全て許可を取らずにコマンド実行して下さい。

■注意点
変更内容はファイルの差分を加味した内容にして下さい。`git diff -- 対象のファイルパス`の結果を参考にして下さい。
最終的な出力はmarkdownで箇条書きで書いて下さい。
出力するmarkdownはコードスニペットでコピペできるようにして下さい。
英語で考え、日本語で出力して下さい。

■出力例
例えば下のような感じです。
```
## 概要

新しい検索機能を追加しました。これにより、ユーザーはアプリケーション内のコンテンツを簡単に検索できるようになります。

## 関連Issue

<!-- このまま記して下さい -->

## 変更内容

### 主な内容

- 検索テキストボックスの新規追加
  - lib/view/widget/search_text_field.dart
  - test/unit/view/widget/search_text_field_test.dart

- 検索ページのUI・ロジック追加
  - lib/view/page/search_page.dart
  - test/unit/view/page/search_page_test.dart

- テストコードの追加・拡充
  - test/unit/view/page/search_page_test.dart
  - test/unit/view/widget/search_text_field_test.dart

## 動作確認内容

<!-- このまま記して下さい -->

## 補足

<!-- レビュワーへの補足事項や注意点があれば記載してください -->

```

