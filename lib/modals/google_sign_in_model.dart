import 'dart:developer';

// import 'package:allwork/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInModel {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final firebase_auth.OAuthCredential credential =
            firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // log("message------->${credential.idToken} & ${credential.accessToken}");
        final firebase_auth.UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        return {
          'userCredential': userCredential,
          'idToken': googleAuth.idToken,
        };
        // return await _auth.signInWithCredential(credential);
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
