import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firebase Authenticationのユーザー状態を監視するプロバイダーです。
///
/// FirebaseAuthの認証状態の変化を監視し、ユーザー情報[User?]をストリームで提供します。
final firebaseAuthUserProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
