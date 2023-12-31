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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCuIqqonudDkand4SH176pD9Sy98DBPXLw',
    appId: '1:444146579674:web:af0cb916898e0477b1cde3',
    messagingSenderId: '444146579674',
    projectId: 'gym-app-b5c64',
    authDomain: 'gym-app-b5c64.firebaseapp.com',
    storageBucket: 'gym-app-b5c64.appspot.com',
    measurementId: 'G-KBNVEFTC4L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-RPqGANgKqXfvOJ-0CUhDRWjGHsNZ7eI',
    appId: '1:444146579674:android:b1a593c7bcfa0434b1cde3',
    messagingSenderId: '444146579674',
    projectId: 'gym-app-b5c64',
    storageBucket: 'gym-app-b5c64.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYNtSuaRX77OUz5WJYntOuGYYDN8WnyLY',
    appId: '1:444146579674:ios:5ee35f4ea7c70798b1cde3',
    messagingSenderId: '444146579674',
    projectId: 'gym-app-b5c64',
    storageBucket: 'gym-app-b5c64.appspot.com',
    iosBundleId: 'com.example.gymapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDYNtSuaRX77OUz5WJYntOuGYYDN8WnyLY',
    appId: '1:444146579674:ios:8080c3753097b932b1cde3',
    messagingSenderId: '444146579674',
    projectId: 'gym-app-b5c64',
    storageBucket: 'gym-app-b5c64.appspot.com',
    iosBundleId: 'com.example.gymapp.RunnerTests',
  );
}
