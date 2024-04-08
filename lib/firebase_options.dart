// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyCxF3ldM-OC2kXwH83ZlFQfpnxAF65Q2Us',
    appId: '1:787470094102:android:5349b4d65a5ad432844a37',
    messagingSenderId: '787470094102',
    projectId: 'masterstudy-app',
    databaseURL: 'https://masterstudy-app.firebaseio.com',
    storageBucket: 'masterstudy-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRDt4SFXB-ov7mCDQoydD_OvE9XoQj7g8',
    appId: '1:787470094102:ios:db2df4db10d31beb844a37',
    messagingSenderId: '787470094102',
    projectId: 'masterstudy-app',
    databaseURL: 'https://masterstudy-app.firebaseio.com',
    storageBucket: 'masterstudy-app.appspot.com',
    androidClientId: '787470094102-49pfn19e9qfj4q0vm2pb26tbfm1m55uh.apps.googleusercontent.com',
    iosClientId: '787470094102-6lp9528tvcfulk5b4f1oj3f2sc26duq2.apps.googleusercontent.com',
    iosBundleId: 'com.edglobal',
  );
}
