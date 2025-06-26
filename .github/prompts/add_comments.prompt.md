---
mode: agent
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runNotebooks', 'runTasks', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI']
---
現在開いているファイルの「クラス」・「関数」・「メソッド」・「外部公開変数」に対して、
docstringコメント（ `///`で始まるコメント ）を日本語で追加してください。
基本的には Flutter/Dart のドキュメントコメントの書き方に従ってください。
ただし、以下の点に注意してください。
- コメントは日本語で書いてください。
- コメントは、コードの内容を繰り返すのではなく、補足する内容にしてください。
- 1行目に簡潔な要約を書いてください。
- 3行目以降に詳細な説明を書いてください。

例
```dart
/// Personクラスは、[name]という名前と[age]の年齢を持つ人を表現します。
///
/// このクラスは、名前と年齢を持つ人を表現するために使用されます。
/// [hello]メソッドを使用して、自己紹介を行うことができます
class Person {
    /// [name]と[age]を引き取りPersonクラスを生成するコンストラクタ
    Person(this.name, this.age) {
        assert(age >= 0, '年齢は0以上の整数でなければなりません。');
    }

    /// 名前
    final String name;

    /// 年齢 (0以上の整数)
    final int age;

    /// 関数の説明
    ///
    /// 詳細な説明
    void hello() {
        print('こんにちは、私は $name です。年齢は $age 歳です。');
    }
}
```
