---
mode: agent
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runNotebooks', 'runTasks', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI']
---

テストを実行し、テストが通るまでテストコードの修正を行なって下さい。

「テスト実行・テストコードとプロダクトコードの解析・原因特定・テストコード修正・テスト再実施・・・」
という流れをループして、テストが通るまで実施続行して下さい。

もしプロダクトコードに問題がある場合は変更せずに私に知らせてルールも終了して下さい。

テストコードを修正できたら、その内容を私に知らせて下さい。

テストコードを書くにあたっては Kent C Dodds の Testing Trophy や Given-When-Then パターン、
Marting Fowler の Test Pyramid やリファクタリングなどのベストプラクティスに従って下さい。

テストコマンド実行にあたっては許可は不要です。