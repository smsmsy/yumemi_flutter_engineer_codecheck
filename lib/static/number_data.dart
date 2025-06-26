/// レイアウトやパディングなど、数値定数をまとめたユーティリティクラスです。
///
/// レスポンシブデザインや余白調整など、UI設計時に利用する定数を一元管理します。
class NumberData {
  /// 横並びレイアウトへ切り替える画面幅の閾値（ピクセル単位）
  static const horizontalLayoutThreshold = 600.0;

  /// 小さい余白のサイズ（ピクセル単位）
  static const paddingSmall = 8.0;

  /// 標準的な余白のサイズ（ピクセル単位）
  static const paddingMedium = 16.0;

  /// 大きい余白のサイズ（ピクセル単位）
  static const paddingLarge = 24.0;

  /// パディングを除いた横並びレイアウトの閾値（ピクセル単位）
  static const double horizontalLayoutThresholdWithoutPadding =
      horizontalLayoutThreshold - paddingLarge * 2;
}
