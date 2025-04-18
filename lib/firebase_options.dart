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
        return windows;
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
    apiKey: 'AIzaSyD7_oNrWtEgCA4H8e3e_PMYNq1fHVIZclQ',
    appId: '1:164391391883:web:7d94629fa0f7eab16e7a8e',
    messagingSenderId: '164391391883',
    projectId: 'focusflow-e2543',
    authDomain: 'focusflow-e2543.firebaseapp.com',
    storageBucket: 'focusflow-e2543.firebasestorage.app',
    measurementId: 'G-99PN21P7H8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxzIEm7UnEM9OkoeupqLv4arpKivvfHUg',
    appId: '1:164391391883:android:6b1f05819e54bc9b6e7a8e',
    messagingSenderId: '164391391883',
    projectId: 'focusflow-e2543',
    storageBucket: 'focusflow-e2543.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBriVsS4eqXrlNaViOe0W72VcabmpvXomo',
    appId: '1:164391391883:ios:badc673ae1d7c03d6e7a8e',
    messagingSenderId: '164391391883',
    projectId: 'focusflow-e2543',
    storageBucket: 'focusflow-e2543.firebasestorage.app',
    iosBundleId: 'com.example.focus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBriVsS4eqXrlNaViOe0W72VcabmpvXomo',
    appId: '1:164391391883:ios:badc673ae1d7c03d6e7a8e',
    messagingSenderId: '164391391883',
    projectId: 'focusflow-e2543',
    storageBucket: 'focusflow-e2543.firebasestorage.app',
    iosBundleId: 'com.example.focus',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD7_oNrWtEgCA4H8e3e_PMYNq1fHVIZclQ',
    appId: '1:164391391883:web:4288d9941d987de36e7a8e',
    messagingSenderId: '164391391883',
    projectId: 'focusflow-e2543',
    authDomain: 'focusflow-e2543.firebaseapp.com',
    storageBucket: 'focusflow-e2543.firebasestorage.app',
    measurementId: 'G-GRR4SJE19M',
  );
}
