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
    apiKey: 'AIzaSyA0CWB20yis3K6L2-gXdJDDWP4Jyz0aFvA',
    appId: '1:781512350014:web:74258b101a12ec4391746f',
    messagingSenderId: '781512350014',
    projectId: 'ltw-app-72333',
    authDomain: 'ltw-app-72333.firebaseapp.com',
    storageBucket: 'ltw-app-72333.appspot.com',
    measurementId: 'G-6EXM3BFRYX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJQvCRB9GSqUvXcDbUT2GU411HPL5TCKM',
    appId: '1:781512350014:android:1678a9856829398b91746f',
    messagingSenderId: '781512350014',
    projectId: 'ltw-app-72333',
    storageBucket: 'ltw-app-72333.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYhtyctUQJjPr1yhsr36lJ5F7n82sUfjE',
    appId: '1:781512350014:ios:1f89ffc756d76c0891746f',
    messagingSenderId: '781512350014',
    projectId: 'ltw-app-72333',
    storageBucket: 'ltw-app-72333.appspot.com',
    iosBundleId: 'com.example.esApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYhtyctUQJjPr1yhsr36lJ5F7n82sUfjE',
    appId: '1:781512350014:ios:1f89ffc756d76c0891746f',
    messagingSenderId: '781512350014',
    projectId: 'ltw-app-72333',
    storageBucket: 'ltw-app-72333.appspot.com',
    iosBundleId: 'com.example.esApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA0CWB20yis3K6L2-gXdJDDWP4Jyz0aFvA',
    appId: '1:781512350014:web:fa9a122f9661e61c91746f',
    messagingSenderId: '781512350014',
    projectId: 'ltw-app-72333',
    authDomain: 'ltw-app-72333.firebaseapp.com',
    storageBucket: 'ltw-app-72333.appspot.com',
    measurementId: 'G-KXSLZ9W68C',
  );
}
