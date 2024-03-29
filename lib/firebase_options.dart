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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAh0NNW7f6tPw9D1ybZ8DfBtK4wYlQ0gKM',
    appId: '1:924338993109:web:39ca734511fddc4cd5af5c',
    messagingSenderId: '924338993109',
    projectId: 'flutter-graph-app-2023',
    authDomain: 'flutter-graph-app-2023.firebaseapp.com',
    storageBucket: 'flutter-graph-app-2023.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUpaf5rYDMr7-zCad-WYIUyKNdamJixJA',
    appId: '1:924338993109:android:53bc418c6aaacd8ad5af5c',
    messagingSenderId: '924338993109',
    projectId: 'flutter-graph-app-2023',
    storageBucket: 'flutter-graph-app-2023.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZQa3hGyfZH3w003RxPBosecSgYZjXaxw',
    appId: '1:924338993109:ios:2fe2df5a3d3d9e0fd5af5c',
    messagingSenderId: '924338993109',
    projectId: 'flutter-graph-app-2023',
    storageBucket: 'flutter-graph-app-2023.appspot.com',
    iosClientId: '924338993109-aid4maih4oi58k88v1v4oi5816hkifom.apps.googleusercontent.com',
    iosBundleId: 'com.example.testProject',
  );
}
