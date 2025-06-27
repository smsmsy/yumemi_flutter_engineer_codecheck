---
mode: agent
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runNotebooks', 'runTasks', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI']
---
入力された文言についての翻訳文言の整備をお願いします。
翻訳文言の整備は以下の手順に従って下さい。

### 1. まずは基本的な翻訳文言の追加をお願いします。

翻訳文言の追加方法は documents/how-to-add-strings.md を参照してください。

### 2. 英語文言のWordingDataクラスへの追加

英語文言は、`lib/l10n/app_localizations*.dart` に追加されます。
この中で変更のあった箇所を、 `lib/static/wording_data.dart` の `WordingData` クラスに追加してください。

■ 注意点
docstringを書くこと
既存の文言はそのまま残すこと

```dart
class WordingData {
    // 既存の文言(そのまま残して下さい。)

    /// 未検索状態の表示用ラベル。リポジトリがまだ検索されていない場合に利用されます。
    static const String inputKeyword = 'Input search keyword';  
    
    // 他の文言も同様に追加
}

### 3. 追加されたキーワードをプロダクトコードに埋め込む

追加したキーワードをプロダクトコードないから検索し、キーワードが使われている箇所を下記のように置換して下さい。
```dart
AppLocalizations.of(context)?.inputKeyword ?? WordingData.inputKeyword,
```
