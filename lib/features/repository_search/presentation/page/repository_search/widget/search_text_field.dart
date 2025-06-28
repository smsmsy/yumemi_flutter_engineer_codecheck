import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 検索用のテキストフィールドを表示するウィジェット
///
/// 入力値の変更やキャンセルボタン、ラベル表示などをサポートします。
class SearchTextField extends StatelessWidget {
  /// 検索テキストフィールドのコンストラクタ
  ///
  /// [controller]でテキストの制御、[onChanged]で入力値の変更時コールバック、
  /// [onCancelButtonPressed]でキャンセルボタン押下時の処理、[labelText]でラベル表示、
  /// [onSubmitted]でエンター押下時の処理を指定できます。
  const SearchTextField({
    required this.controller,
    super.key,
    this.onChanged,
    this.onCancelButtonPressed,
    this.labelText,
    this.onSubmitted,
  });

  /// テキストフィールドのコントローラー
  ///
  /// 入力値の取得や制御に利用します。
  final TextEditingController controller;

  /// 入力値が変更されたときに呼ばれるコールバック
  final void Function(String)? onChanged;

  /// キャンセルボタンが押されたときに呼ばれるコールバック
  final void Function()? onCancelButtonPressed;

  /// テキストフィールドのラベルテキスト
  final String? labelText;

  /// 入力が確定（エンター）されたときに呼ばれるコールバック
  final void Function(String)? onSubmitted;

  @override
  /// 検索用テキストフィールドのウィジェットツリーを構築します。
  ///
  /// アイコンやキャンセルボタン付きのテキストフィールドを返します。
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: onCancelButtonPressed,
            icon: const Icon(Icons.cancel),
          ),
          labelText: labelText,
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TextEditingController?>('controller', controller),
    );
    properties.add(
      ObjectFlagProperty<void Function(String p1)?>.has('onChanged', onChanged),
    );
    properties.add(
      DiagnosticsProperty<void Function()?>(
        'onCancelButtonPressed',
        onCancelButtonPressed,
      ),
    );
    properties.add(StringProperty('labelText', labelText));
    properties.add(
      ObjectFlagProperty<void Function(String p1)?>.has(
        'onSubmitted',
        onSubmitted,
      ),
    );
  }
}
