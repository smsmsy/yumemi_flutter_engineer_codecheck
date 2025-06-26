---
mode: agent
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runNotebooks', 'runTasks', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI']
---

現在開いているファイルについてテストを書いて下さい。

テストを書き始める前にどのようなテストを書くかを考えて下さい。

開いているファイルの内容が単独でテスト可能な場合は、単体テストを作成して下さい。
開いているファイルの内容が別のファイルに依存している場合は、単体テストではなく、統合テストを作成して下さい。

もし、開いているファイルがテスト可能でない場合は、その理由を説明して下さい。
また、テストを書くために必要な情報が不足している場合は、その情報を尋ねて下さい。

テストを書いた後は、テストを実行し、全てのテストが通ることを確認して下さい。
もしテストが通らなかった場合は、どのテストが失敗したかを確認し、必要に応じて修正を行って下さい。

以下のことに必ず従って下さい
- DON'T
  - プロダクトコードを変更しないで下さい。
  - テストの実行に必要なコードを変更しないで下さい。
  - テストの実行に必要なファイルを削除しないで下さい。
  - テストの実行に必要なファイルを追加しないで下さい。
  - 既存のテストを変更しないで下さい。

テストを書く際には、以下の点に注意して下さい。
- テストは、開いているファイルの機能を検証するものであり、実際の動作を模倣するものではありません。
- テストは、開いているファイルの機能を検証するために必要な最小限の情報を使用して下さい。

テスト戦略については以下を参考にして下さい。
- テストの考え方については Kent C. Dodds の「Testing Trophy」「Given When Thenパターン」を参考にして下さい。
  - テスティングトロフィについて：https://kentcdodds.com/blog/static-vs-unit-vs-integration-vs-e2e-tests
  - テストのバッドプラクティス：https://kentcdodds.com/blog/common-testing-mistakes

- テストの書き方については、以下のリソースを参考にして下さい。
  - Flutterのテストガイド：https://flutter.dev/docs/testing
  - Dartのテストガイド：https://dart.dev/guides/testing
  - Mockitoの使い方：https://pub.dev/packages/mockito