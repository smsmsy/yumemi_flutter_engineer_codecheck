import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/auth_gate/auth_gate.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/github_auth/github_auth_page.dart';
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
  static const search = '/search';
  static const details = 'details';
  static const githubAuth = '/githubAuth';
}

/// GoRouterのルーティング設定を生成します。
///
/// ホーム画面とリポジトリ詳細画面へのルートを定義し、
/// 詳細画面への遷移時にはフェードトランジションを適用します。
GoRouter createGoRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        redirect: (context, state) {
          final user = FirebaseAuth.instance.currentUser;
          final loggingIn = state.matchedLocation == AppRoutes.githubAuth;

          if (user == null && !loggingIn) {
            // 未ログインならログインページへ
            return AppRoutes.githubAuth;
          }
          if (user != null && loggingIn) {
            // ログイン済みなら検索ページへ
            return AppRoutes.search;
          }
          // それ以外はリダイレクトしない
          return null;
        },
        path: AppRoutes.root,
        name: 'authGate',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: AppRoutes.githubAuth,
        name: 'githubAuth',
        builder: (context, state) {
          return const GitHubAuthPage();
        },
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) {
          // リポジトリ検索ページのビルダー
          return const RepositorySearchPage();
        },
        routes: [
          GoRoute(
            path: AppRoutes.details,
            name: 'details',
            pageBuilder: (context, state) {
              final repository = state.extra! as Repository;
              return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                reverseTransitionDuration: const Duration(
                  milliseconds: 500,
                ),
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
