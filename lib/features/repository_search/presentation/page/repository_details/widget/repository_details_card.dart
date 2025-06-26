import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_card_ui_builder.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_builder.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_monitor.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/widget/repository_hero_animation_state.dart';

/// GitHubリポジトリ詳細表示ウィジェット
///
/// リポジトリの情報をカード形式で表示
/// レイアウトは画面幅に応じて縦横切り替え
class RepositoryDetailsCard extends StatefulWidget {
  const RepositoryDetailsCard({required this.repository, super.key});
  final Repository repository;

  @override
  State<RepositoryDetailsCard> createState() => _RepositoryDetailsCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Repository>('repository', repository));
  }
}

class _RepositoryDetailsCardState extends State<RepositoryDetailsCard>
    with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late HeroAnimationState _animationState;
  late HeroAnimationMonitor _animationMonitor;

  // Lazy initialization のためのキャッシュ
  RepositoryCardUIBuilder? _cachedUIBuilder;
  RepositoryHeroAnimationBuilder? _cachedHeroAnimationBuilder;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _setupAnimationController();
  }

  /// 全コンポーネントの初期化
  ///
  /// アニメーション状態管理とモニタリングクラスを初期化する
  /// 初期化処理を一箇所にまとめることで保守性を向上
  void _initializeComponents() {
    _animationState = HeroAnimationState();
    _animationMonitor = HeroAnimationMonitor(_animationState);
  }

  /// アニメーションコントローラーのセットアップ
  ///
  /// Heroアニメーションのコントローラーを作成し、状態監視を開始する
  /// セットアップロジックを分離することで、責任を明確化
  void _setupAnimationController() {
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationMonitor.monitorControllerAnimation(_heroAnimationController);

    // 状態変化の監視
    _animationState.addListener(_onAnimationStateChanged);
  }

  /// アニメーション状態変化時のコールバック
  ///
  /// アニメーション状態が変わった時に呼ばれる処理
  /// build中の呼び出しによるエラーを防ぐため、フレーム後に実行を延期している
  ///
  /// 【注意】setState()をbuild中に呼ぶとエラーになるため、
  /// addPostFrameCallback()を使用して安全なタイミングで実行
  void _onAnimationStateChanged() {
    if (mounted) {
      // build中の呼び出しを避けるため、フレーム後に実行を延期
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            // キャッシュをクリアして再生成を促す
            _cachedUIBuilder = null;
            _cachedHeroAnimationBuilder = null;
          });
        }
      });
    }
  }

  /// UIBuilderの遅延生成
  ///
  /// 必要になった時点でUIBuilderインスタンスを作成する
  /// キャッシュ機能により、同じ状態なら再利用してパフォーマンスを向上
  ///
  /// 【利点】
  /// - メモリ使用量の最適化
  /// - 不要な再生成を防止
  /// - アニメーション状態に応じた適切なUIBuilder生成
  RepositoryCardUIBuilder get _uiBuilder {
    _cachedUIBuilder ??= RepositoryCardUIBuilder(
      repository: widget.repository,
      isHeroAnimationCompleted: _animationState.isCompleted,
      isHeroAnimationInProgress: _animationState.isInProgress,
    );
    return _cachedUIBuilder!;
  }

  /// HeroAnimationBuilderの遅延生成
  ///
  /// 必要になった時点でHeroAnimationBuilderインスタンスを作成する
  /// UIBuilderに依存するため、UIBuilderが先に生成される
  ///
  /// 【設計上の注意】
  /// - uiBuilderプロパティを通じてUIBuilderのgetterを呼び出す
  /// - これにより依存関係が明確になり、適切な順序で初期化される
  RepositoryHeroAnimationBuilder get _heroAnimationBuilder {
    _cachedHeroAnimationBuilder ??= RepositoryHeroAnimationBuilder(
      uiBuilder: _uiBuilder,
      animationMonitor: _animationMonitor,
    );
    return _cachedHeroAnimationBuilder!;
  }

  /// アニメーション完了状態の取得
  ///
  /// 外部から直接 _animationState にアクセスするのを防ぐ
  /// アニメーションが完了しているかどうかを安全に取得できる
  bool get isHeroAnimationCompleted => _animationState.isCompleted;

  /// アニメーション進行状態の取得
  ///
  /// 外部から直接 _animationState にアクセスするのを防ぐ
  /// アニメーションが進行中かどうかを安全に取得できる
  bool get isHeroAnimationInProgress => _animationState.isInProgress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        // ヒーローアニメーションを使用してリポジトリの詳細を表示
        // 検索画面のリストビューと同一のタグを使用することで実現している
        transitionOnUserGestures: true,
        tag: 'repository-${widget.repository.name}',
        // Hero アニメーションの詳細制御
        flightShuttleBuilder: _heroAnimationBuilder.buildFlightShuttle,
        child: AnimatedBuilder(
          animation: _animationState,
          builder: (context, child) {
            // キャッシュされたUIBuilderを使用（状態変化時は自動で再作成される）
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

  /// アニメーション関連コンポーネントの破棄
  ///
  /// ウィジェットが破棄される際にリソースを適切に解放する
  /// メモリリークを防ぐため、AnimationControllerとStateを破棄
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
