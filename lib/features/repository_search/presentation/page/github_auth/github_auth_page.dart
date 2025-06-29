import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:simple_logger/simple_logger.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/github_access_token_provider.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/go_router_provider.dart';

/// GitHub認証画面を提供するStatefulWidgetです。
///
/// この画面はGitHub認証のUIと認証処理を提供し、
/// ユーザーの認証状態に応じて画面を切り替えます。
class GitHubAuthPage extends ConsumerStatefulWidget {
  /// GitHubAuthPageのコンストラクタです。
  ///
  /// [key]はウィジェットの一意性を保つために使用されます。
  const GitHubAuthPage({super.key});

  @override
  ConsumerState<GitHubAuthPage> createState() => _GitHubAuthPageState();
}

/// GitHub認証画面の状態を管理するStateクラスです。
///
/// FirebaseAuthの認証状態を監視し、
/// UIの切り替えやGitHub認証処理を行います。
class _GitHubAuthPageState extends ConsumerState<GitHubAuthPage> {
  /// Firebase Authenticationのインスタンスです。
  ///
  /// Firebaseの認証サービスと通信するために使用します。
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ログ出力用のSimpleLoggerインスタンスです。
  final _logger = SimpleLogger();

  /// 現在のユーザー情報（ログインしていなければnull）
  ///
  /// この値に基づいてUIを切り替えます。
  User? _user;

  /// GitHubアクセストークンを保存するための変数です。
  String? _githubAccessToken;

  @override
  void initState() {
    super.initState();

    /// FirebaseAuthの認証状態の変化を監視し、ユーザー情報を更新します。
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
      if (user == null) {
        _logger.info('ユーザーは現在ログアウトしています');
      } else {
        _logger.info('ユーザーがログインしました: ${user.displayName ?? user.email}');
      }
    });
  }

  /// 画面のUIを構築します。
  ///
  /// ユーザーの認証状態に応じて、サインイン画面またはログイン済み画面を表示します。
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub認証'),
      ),
      body: Center(
        child: _user == null ? _buildSignInUI() : _buildLoggedInUI(),
      ),
    );
  }

  /// ログインしていない場合のUIウィジェットを構築します。
  ///
  /// GitHubでサインインするボタンや、ログインせずに続行するボタンを表示します。
  Widget _buildSignInUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.tonalIcon(
          onPressed: signInWithGitHub,
          icon: Image.asset(
            Theme.brightnessOf(context) == Brightness.dark
                ? 'asset/image/github-mark-white.png'
                : 'asset/image/github-mark.png',
            height: 36,
          ),
          label: Text(
            'GitHubでサインイン',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () async {
            await GoRouter.of(context).pushReplacement(AppRoutes.search);
          },
          child: const Text('ログインせずに続行する'),
        ),
      ],
    );
  }

  /// ログインしている場合のUIウィジェットを構築します。
  ///
  /// ログイン成功メッセージと、検索画面へ移動するボタンを表示します。
  Widget _buildLoggedInUI() {
    Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) async {
        if (!mounted) {
          timer.cancel();
          await GoRouter.of(context).pushReplacement(AppRoutes.search);
        }
      },
    );
    return Center(
      child: Column(
        children: [
          Text(
            'ログイン成功しました！',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              await GoRouter.of(context).pushReplacement(AppRoutes.search);
            },
            child: const Text('検索画面へ移動する'),
          ),
        ],
      ),
    );
  }

  /// GitHub認証処理を実行します。
  ///
  /// Webとモバイルで処理を分岐し、認証後はカスタムトークンでFirebaseにサインインします。
  /// 認証成功時はアクセストークンをProviderに保存します。
  Future<void> signInWithGitHub() async {
    if (kIsWeb) {
      await _signInWithGitHubWeb();
      return;
    }
    await _signInWithGitHubMobile();
  }

  /// Web環境でのGitHub認証処理を行います。
  ///
  /// Firebase AuthのGitHubプロバイダーを利用してWeb認証を行います。
  Future<void> _signInWithGitHubWeb() async {
    final githubProvider = GithubAuthProvider();
    try {
      await _auth.signInWithPopup(githubProvider);
      // アクセストークンは仕様上取得できない場合が多い
    } catch (error, stackTrace) {
      _logger.warning(
        'WebでのGitHub認証エラー',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// モバイル環境でのGitHub認証処理を行います。
  ///
  /// FlutterWebAuth2を利用してGitHub認証を行い、カスタムトークンでFirebaseにサインインします。
  Future<void> _signInWithGitHubMobile() async {
    const clientId = 'Iv23lituienRCCjD6uzl';
    const redirectUri = 'yumemi.flutter://auth'; // カスタムスキーム
    const url =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=read:user';
    const callbackUrlScheme = 'yumemi.flutter';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
      );
      final code = _requireAuthCode(result);
      final token = await _fetchCustomTokenAndAccessToken(code);
      await _auth.signInWithCustomToken(token);
    } catch (error, stackTrace) {
      _logger.warning('GitHub認証エラー', error: error, stackTrace: stackTrace);
    }
  }

  /// 認証結果からGitHub認証コードを抽出します。
  ///
  /// 認証コードが取得できない場合は例外を投げます。
  String _requireAuthCode(String result) {
    final code = Uri.parse(result).queryParameters['code'];
    if (code == null) {
      throw Exception('GitHub認証コードが取得できませんでした');
    }
    return code;
  }

  /// GitHub認証コードからカスタムトークンとアクセストークンを取得します。
  ///
  /// 成功時はアクセストークンをProviderに保存し、カスタムトークンを返します。
  Future<String> _fetchCustomTokenAndAccessToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://us-central1-flutter-engineer-codeche-1f6a1.cloudfunctions.net/githubAuth',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );
      if (response.statusCode != 200) {
        throw Exception('カスタムトークン取得失敗: ${response.body}');
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final token = body['token'] as String;
      _githubAccessToken = body['githubAccessToken'] as String?;
      ref.read(githubAccessTokenProvider.notifier).update(_githubAccessToken);
      return token;
    } catch (error, stackTrace) {
      _logger.warning(
        'カスタムトークン取得エラー',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
