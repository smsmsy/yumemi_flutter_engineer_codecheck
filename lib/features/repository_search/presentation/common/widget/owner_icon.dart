import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';

/// リポジトリのオーナーのアバター画像を表示するウィジェット
///
/// オーナーが設定されていない場合や画像の読み込みに失敗した場合はデフォルトのアイコンを表示
/// 読み込み中はCircularProgressIndicatorを表示
class OwnerIcon extends StatelessWidget {
  const OwnerIcon({required this.repository, this.diameter, super.key});

  /// オーナーのアバター画像の直径
  final double? diameter;

  final Repository repository;

  @override
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
  /// Ownerがセットされてなかったりエラー時に表示されるウィジェット
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
  /// 読み込み中はCircularProgressIndicatorを表示し、完了時は子ウィジェットをそのまま表示
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
/// 影と背景色を持つ円形のアバターを表示
class _DecoratedAvatarCircle extends StatelessWidget {
  const _DecoratedAvatarCircle({required this.child, this.diameter});

  final double? diameter;
  final Widget child;

  @override
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
