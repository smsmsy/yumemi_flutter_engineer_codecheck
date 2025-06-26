import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';

/// リポジトリのオーナーのアバター画像を表示するウィジェット
///
/// オーナーが設定されていない場合や画像の読み込みに失敗した場合はデフォルトのアイコンを表示します。
/// 読み込み中はCircularProgressIndicatorを表示します。
class OwnerIcon extends StatelessWidget {
  /// [repository]のオーナーのアバター画像を表示するためのコンストラクタ
  ///
  /// [repository]は表示対象のリポジトリ情報を渡します。
  /// [diameter]はアバター画像の直径を指定します。
  const OwnerIcon({required this.repository, this.diameter, super.key});

  /// オーナーのアバター画像の直径
  ///
  /// アバター画像のサイズを指定します。
  final double? diameter;

  /// 表示対象のリポジトリ情報
  ///
  /// オーナー情報やアバター画像URLの取得に利用します。
  final Repository repository;

  @override
  /// オーナーのアバター画像またはデフォルトアイコンを表示するWidgetを構築します。
  ///
  /// 画像の読み込み状態に応じて表示内容を切り替えます。
  Widget build(BuildContext context) {
    final avatarUrl = repository.owner?.avatarUrl;

    if (avatarUrl == null || avatarUrl.isEmpty) {
      return _buildDefaultAvatar(context);
    }

    return _DecoratedAvatarCircle(
      diameter: diameter,
      child: ClipOval(
        child: Image.network(
          avatarUrl,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          errorBuilder: _buildDefaultAvatar,
          loadingBuilder: _buildImageLoadingIndicator,
        ),
      ),
    );
  }

  /// デフォルトのアバターを構築する
  ///
  /// Ownerがセットされていなかったりエラー時に表示されるウィジェットを返します。
  Widget _buildDefaultAvatar(
    BuildContext context, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    return _DecoratedAvatarCircle(
      diameter: diameter,
      child: Icon(
        Icons.person,
        size: diameter,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// ネットワーク画像のローディング表示を構築する
  ///
  /// 読み込み中はCircularProgressIndicatorを表示し、完了時は子ウィジェットをそのまま表示します。
  Widget _buildImageLoadingIndicator(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    // 読み込み完了時は子ウィジェットをそのまま表示
    if (loadingProgress == null) {
      return child;
    }

    // 読み込み進捗を計算
    final progress = _calculateLoadingProgress(loadingProgress);

    return _DecoratedAvatarCircle(
      diameter: diameter,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 2,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  /// 読み込み進捗を計算する（0.0〜1.0の範囲）
  ///
  /// [loadingProgress]から読み込み済みバイト数と総バイト数を用いて進捗率を計算します。
  /// 総バイト数が不明な場合はnullを返します。
  double? _calculateLoadingProgress(ImageChunkEvent loadingProgress) {
    final expectedTotalBytes = loadingProgress.expectedTotalBytes;
    if (expectedTotalBytes == null) {
      return null; // 不定進捗
    }

    return loadingProgress.cumulativeBytesLoaded / expectedTotalBytes;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
    properties.add(DoubleProperty('diameter', diameter));
  }
}

/// 飾りが施されたCircleAvatarウィジェット
///
/// 影と背景色を持つ円形のアバターを表示します。
class _DecoratedAvatarCircle extends StatelessWidget {
  /// [child]を円形に装飾して表示するコンストラクタ
  ///
  /// [diameter]で円の直径を指定できます。
  const _DecoratedAvatarCircle({required this.child, this.diameter});

  /// 円形アバターの直径
  ///
  /// 円のサイズを指定します。
  final double? diameter;

  /// 円形アバター内に表示するウィジェット
  ///
  /// 通常はネットワーク画像またはアイコンが入ります。
  final Widget child;

  @override
  /// 円形の装飾を施したWidgetを構築します。
  ///
  /// 影や背景色を付与した円形のボックス内に[child]を表示します。
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.shadow.withAlpha((255 * 0.3).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('diameter', diameter));
  }
}
