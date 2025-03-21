// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzO7NVpBbzduYw6hfqYAX9aisuK4Ey3vc',
    appId: '1:284263985070:android:7ce20aa69f2ec9ca86e23f',
    messagingSenderId: '284263985070',
    projectId: 'mafatih-ul-jinan',
    storageBucket: 'mafatih-ul-jinan.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUX2wKOLwGaxw4XzvQoUR0q3Fty9v0N3w',
    appId: '1:284263985070:ios:283a284db0b9139c86e23f',
    messagingSenderId: '284263985070',
    projectId: 'mafatih-ul-jinan',
    storageBucket: 'mafatih-ul-jinan.firebasestorage.app',
    androidClientId: '284263985070-nnpb9k5l0oc9v3008ot15m9aka74v6dn.apps.googleusercontent.com',
    iosClientId: '284263985070-555qs2aqse6g03rh0cf13bmlv6r51u0j.apps.googleusercontent.com',
    iosBundleId: 'com.mafatihuljinan.online',
  );
}
