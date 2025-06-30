import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/firebase_auth_user_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/go_router_provider.dart';

/// GitHubのサインイン・サインアウトボタンを提供するウィジェットです。
///
/// ユーザーの認証状態に応じて、サインインまたはサインアウトのアイコンボタンを表示します。
class GitHubSignInOutButton extends ConsumerWidget {
  /// GitHubSignInOutButtonのコンストラクタ
  ///
  /// [key]はウィジェットの一意性を識別するために使用されます。
  const GitHubSignInOutButton({super.key});

  /// ユーザーの認証状態に応じて、サインイン・サインアウト・リトライ・ローディングの各UIを表示します。
  ///
  /// 認証されていない場合はサインインボタン、認証済みの場合はサインアウトボタン、
  /// エラー時はリトライボタン、ローディング時はインジケーターを表示します。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(firebaseAuthUserProvider);
    return authUser.when(
      data: (data) {
        if (data == null) {
          return IconButton(
            onPressed: () async {
              await GoRouter.of(
                context,
              ).pushReplacement(AppRoutes.githubAuth);
            },
            icon: const Icon(Icons.login),
          );
        }
        return IconButton(
          onPressed: () async {
            if (context.mounted) {
              await FirebaseAuth.instance.signOut();
            }
          },
          icon: const Icon(Icons.logout),
        );
      },
      error: (error, stackTrace) {
        return IconButton(
          onPressed: () {
            ref.invalidate(firebaseAuthUserProvider);
          },
          icon: const Icon(Icons.replay),
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
