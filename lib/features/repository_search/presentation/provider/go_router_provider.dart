import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_details/repository_details_page.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/repository_search_page.dart';

/// GoRouterのインスタンスを提供するProviderです。
///
/// アプリ全体でルーティングを管理するための[GoRouter]をRiverpodで提供します。
final goRouterProvider = Provider<GoRouter>(
  (ref) => createGoRouter(),
);

/// アプリ内で使用するルートパスを定義するクラスです。
///
/// [root]はホーム画面、[details]はリポジトリ詳細画面のパスを表します。
class AppRoutes {
  static const root = '/';
  static const details = 'details';
}

/// GoRouterのルーティング設定を生成します。
///
/// ホーム画面とリポジトリ詳細画面へのルートを定義し、
/// 詳細画面への遷移時にはフェードトランジションを適用します。
GoRouter createGoRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.root,
        name: 'home',
        builder: (context, state) => const RepositorySearchPage(),
        routes: [
          GoRoute(
            path: AppRoutes.details,
            name: 'details',
            pageBuilder: (context, state) {
              final repository = state.extra! as Repository;
              return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                reverseTransitionDuration: const Duration(milliseconds: 500),
                child: RepositoryDetailsPage(repository: repository),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
  );
}
