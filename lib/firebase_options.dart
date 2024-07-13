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
    apiKey: 'AIzaSyBsc5gyURR8Bxln9_Jxw0GwghkgiBum6LE',
    appId: '1:713042164872:web:08f03fac565bec359fb33d',
    messagingSenderId: '713042164872',
    projectId: 'login-ad6eb',
    authDomain: 'login-ad6eb.firebaseapp.com',
    storageBucket: 'login-ad6eb.appspot.com',
    measurementId: 'G-4E9KNB5LED',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBo46oUR7hkcEYyLv4z3xRX_SC0s3G7uBk',
    appId: '1:713042164872:android:37ee1a517042d4859fb33d',
    messagingSenderId: '713042164872',
    projectId: 'login-ad6eb',
    storageBucket: 'login-ad6eb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7XA19znaSZng-ab9AOcDgW66YfK7bJk4',
    appId: '1:713042164872:ios:6a733cef7e1737809fb33d',
    messagingSenderId: '713042164872',
    projectId: 'login-ad6eb',
    storageBucket: 'login-ad6eb.appspot.com',
    iosBundleId: 'com.example.firebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC7XA19znaSZng-ab9AOcDgW66YfK7bJk4',
    appId: '1:713042164872:ios:6a733cef7e1737809fb33d',
    messagingSenderId: '713042164872',
    projectId: 'login-ad6eb',
    storageBucket: 'login-ad6eb.appspot.com',
    iosBundleId: 'com.example.firebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBsc5gyURR8Bxln9_Jxw0GwghkgiBum6LE',
    appId: '1:713042164872:web:2a34052167821d4a9fb33d',
    messagingSenderId: '713042164872',
    projectId: 'login-ad6eb',
    authDomain: 'login-ad6eb.firebaseapp.com',
    storageBucket: 'login-ad6eb.appspot.com',
    measurementId: 'G-XPJ4CXJ792',
  );
}
