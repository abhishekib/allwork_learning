import 'dart:developer';

import 'package:allwork/utils/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInModel {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: ApiConstants.googleClientId,
    scopes: ['email', 'profile'],
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // log('Access Token: ${googleAuth.accessToken}');
        // log('ID Token: ${googleAuth.idToken}');
        return {
          'displayName': googleUser.displayName,
          'email': googleUser.email,
          'photoUrl': googleUser.photoUrl,
          'idToken': googleAuth.idToken,
          'accessToken': googleAuth.accessToken,
        };
      }
    } catch (e) {
      log('message: Google Sign-In failed: $e');
      throw Exception('Google Sign-In failed: $e');
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }
}
