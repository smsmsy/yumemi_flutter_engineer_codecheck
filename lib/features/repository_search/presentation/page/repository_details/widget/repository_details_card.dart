import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_card_ui_builder.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_builder.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_monitor.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_state.dart';

/// GitHubリポジトリの詳細情報をカード形式で表示するウィジェットです。
///
/// 画面幅に応じて縦横レイアウトを切り替え、アニメーション付きでリポジトリ情報を表示します。
class RepositoryDetailsCard extends StatefulWidget {
  /// [repository]の情報を表示するカードを生成します。
  ///
  /// [repository]：表示対象のリポジトリ情報
  const RepositoryDetailsCard({required this.repository, super.key});

  /// 表示するリポジトリ情報
  final Repository repository;

  @override
  State<RepositoryDetailsCard> createState() => _RepositoryDetailsCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

/// RepositoryDetailsCardの状態管理クラスです。
///
/// アニメーションやUIビルダーのキャッシュ管理を行います。
class _RepositoryDetailsCardState extends State<RepositoryDetailsCard>
    with TickerProviderStateMixin {
  /// Heroアニメーション用のコントローラー
  ///
  /// リポジトリカードのHeroアニメーションを制御するためのコントローラーです。
  /// アニメーションの進行状況を管理し、UIの更新を行います。
  late AnimationController _heroAnimationController;

  /// アニメーション状態とモニターを管理するためのインスタンス
  ///
  /// Heroアニメーションの進行状況を追跡し、UIの更新を行います。
  late HeroAnimationState _animationState;

  /// Heroアニメーションの状態を監視するモニター
  ///
  /// アニメーションの進行状況を管理し、UIの更新をトリガーします。
  late HeroAnimationMonitor _animationMonitor;

  /// UIBuilderのキャッシュ
  ///
  /// リポジトリカードのUIを構築するためのビルダーをキャッシュします。
  /// 同じ状態であれば再利用し、パフォーマンスを向上させます。
  RepositoryCardUIBuilder? _cachedUIBuilder;

  /// HeroAnimationBuilderのキャッシュ
  ///
  /// Heroアニメーションのビルダーをキャッシュします。
  /// 同じ状態であれば再利用し、パフォーマンスを向上させます。
  RepositoryHeroAnimationBuilder? _cachedHeroAnimationBuilder;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _setupAnimationController();
  }

  /// アニメーション状態やモニターの初期化を行います。
  void _initializeComponents() {
    _animationState = HeroAnimationState();
    _animationMonitor = HeroAnimationMonitor(_animationState);
  }

  /// Heroアニメーション用コントローラーのセットアップを行います。
  void _setupAnimationController() {
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationMonitor.monitorControllerAnimation(_heroAnimationController);
    _animationState.addListener(_onAnimationStateChanged);
  }

  /// アニメーション状態が変化した際のコールバックです。
  ///
  /// build中のsetState呼び出しによるエラーを防ぐため、addPostFrameCallbackで遅延実行します。
  void _onAnimationStateChanged() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _cachedUIBuilder = null;
            _cachedHeroAnimationBuilder = null;
          });
        }
      });
    }
  }

  /// UIBuilderを必要時に生成し、同じ状態ならキャッシュを再利用します。
  RepositoryCardUIBuilder get _uiBuilder {
    _cachedUIBuilder ??= RepositoryCardUIBuilder(
      repository: widget.repository,
      isHeroAnimationCompleted: _animationState.isCompleted,
      isHeroAnimationInProgress: _animationState.isInProgress,
    );
    return _cachedUIBuilder!;
  }

  /// HeroAnimationBuilderを必要時に生成し、同じ状態ならキャッシュを再利用します。
  RepositoryHeroAnimationBuilder get _heroAnimationBuilder {
    _cachedHeroAnimationBuilder ??= RepositoryHeroAnimationBuilder(
      uiBuilder: _uiBuilder,
      animationMonitor: _animationMonitor,
    );
    return _cachedHeroAnimationBuilder!;
  }

  /// アニメーションが完了しているかどうかを返します。
  bool get isHeroAnimationCompleted => _animationState.isCompleted;

  /// アニメーションが進行中かどうかを返します。
  bool get isHeroAnimationInProgress => _animationState.isInProgress;

  /// リポジトリ詳細カードのUIを構築します。
  ///
  /// HeroアニメーションとAnimatedBuilderを組み合わせて、状態変化に応じたUIを表示します。
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        transitionOnUserGestures: true,
        tag: 'repository-${widget.repository.id}-${widget.repository.fullName}',
        flightShuttleBuilder: _heroAnimationBuilder.buildFlightShuttle,
        child: AnimatedBuilder(
          animation: _animationState,
          builder: (context, child) {
            return _uiBuilder.buildCardContent(context);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposeAnimationComponents();
    super.dispose();
  }

  /// アニメーション関連のリソースを破棄します。
  void _disposeAnimationComponents() {
    _heroAnimationController.dispose();
    _animationState.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<bool>(
        'isHeroAnimationCompleted',
        isHeroAnimationCompleted,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'isHeroAnimationInProgress',
        isHeroAnimationInProgress,
      ),
    );
  }
}
