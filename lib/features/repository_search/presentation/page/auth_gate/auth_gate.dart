// 認証状態のゲートを管理するウィジェット
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/firebase_auth_user_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(firebaseAuthUserProvider);

    return authUser.when(
      data: (user) {
        // リダイレクティングを待つ
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // ローディング中の表示
          ),
        );
      },
      loading:
          () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // ローディング中の表示
            ),
          ),
      error: (error, stackTrace) {
        final logger = SimpleLogger();
        logger.warning(
          'AuthGate error: $error',
          stackTrace: stackTrace,
        );
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Text('Error: $error'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // エラー発生時の再試行ボタン
                    ref.invalidate(firebaseAuthUserProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ), // エラーメッセージの表示
          ),
        );
      },
    );
  }
}
