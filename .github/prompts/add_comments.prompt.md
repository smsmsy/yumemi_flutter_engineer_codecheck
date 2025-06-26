---
mode: agent
tools: ['changes', 'codebase', 'editFiles', 'extensions', 'fetch', 'findTestFiles', 'githubRepo', 'new', 'openSimpleBrowser', 'problems', 'runCommands', 'runNotebooks', 'runTasks', 'search', 'searchResults', 'terminalLastCommand', 'terminalSelection', 'testFailure', 'usages', 'vscodeAPI']
---
現在開いているファイルの「クラス」・「関数」・「メソッド」・「外部公開変数」に対して、
docstringコメント（ `///`で始まるコメント ）を日本語で追加してください。
基本的には Flutter/Dart のドキュメントコメントの書き方に従ってください。
ただし、以下の点に注意してください。
- **プロダクトコードの内容は一切変更しないでください。**
- コメントは**日本語**で書いてください。
- **1行目に簡潔な要約**を書き、**3行目以降に詳細な説明**を書いてください。
- なお要約のみで説明が十分な場合は、詳細な説明は省略してください。
- **プロダクトコードの内容は一切変更しないでください。**
- StatelessWidget や StatefulWidget の build メソッドのように、特定の機能を持つメソッドには機能の説明を記述してください。
- 一方でdebugFillPropertiesのように直接的な機能を持たないメソッドには、説明を書かないて下さい。
- 特に複雑なロジックを持つメソッド(10行以上目安)には、処理の流れや意図を詳しく説明してください。
- クラスのコンストラクタには、引数がどのようにクラスで用いられるかの説明を記述してください。
- 外部公開変数には、変数の役割や使用方法を記述してください。
- **プロダクトコードの内容は一切変更しないでください。**

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
