import 'dart:developer';

import 'package:allwork/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: ApiConstants.googleClientId,
    scopes: ['email', 'profile'],
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // log('Access Token: ${googleAuth.accessToken}');
        // log('ID Token: ${googleAuth.idToken}');
        // return {
        //   'displayName': googleUser.displayName,
        //   'email': googleUser.email,
        //   'photoUrl': googleUser.photoUrl,
        //   'idToken': googleAuth.idToken,
        //   'accessToken': googleAuth.accessToken,
        // };
        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      log('message: Google Sign-In failed: $e');
      throw Exception('Google Sign-In failed: $e');
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
