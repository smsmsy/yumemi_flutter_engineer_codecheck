---
mode: agent
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runNotebooks', 'runTasks', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI']
---

ここまでの変更内容を単一の機能に分けてコミットして下さい。

■注意点
- 実例についてはこれまでのコミットメッセージを参考にして下さい
- コミットメッセージは日本語で書いて下さい。
- 単一の機能の単位で分けてコミットして下さい。
  - 例えば、機能追加とバグ修正を同時に行った場合は、それぞれ別のコミットに分けて下さい。

まず、現在のブランチを確認して下さい。
次に、`origin/main`ブランチと現在のブランチの差分を確認して下さい。
その差分をもとに、どのような変更が行われたかをまとめて下さい。
その後、以下の形式に従ってコミットメッセージを作成し、コミットを実行して下さい。

コミットメッセージは、以下の形式に従ってください。
```
<type>(<scope>): <subject>

<body>
<footer>
```
- `<type>`は変更の種類を示すもので、以下のいずれかを使用してください。
    - feat: 新機能の追加
    - fix: バグ修正
    - docs: ドキュメントの変更
    - style: フォーマットの変更（コードの動作に影響しない変更）
    - refactor: リファクタリング（コードの動作に影響しない変更）
    - perf: パフォーマンスの改善
    - test: テストの追加・修正
    - chore: その他の変更（ビルドプロセスや補助ツールの変更など）
- `<scope>`は変更の範囲を示すもので、任意です。
- `<subject>`は変更内容の要約で、50文字以内で簡潔に記述してください。
- `<body>`は変更内容の詳細な説明で、必要に応じて記述してください。
- `<footer>`は関連するチケット番号やその他の情報を記述するためのものです。
