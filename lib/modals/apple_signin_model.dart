import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInModel {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  Future<Map<String, dynamic>?> signInWithApple() async {
    if (!Platform.isIOS) {
      throw Exception("Apple Sign-In is only supported on iOS.");
    }

    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential =
          firebase_auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final firebase_auth.UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);

      return {
        'userCredential': userCredential,
        'idToken': appleCredential.identityToken,
        'email': appleCredential.email,
        'name': appleCredential.givenName ?? "Anonymous",
      };
    } catch (e) {
      throw Exception("Apple Sign-In failed: $e");
    }
  }

  Future<void> signOutFromApple() async {
    await _auth.signOut();
  }
}
