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
    apiKey: 'AIzaSyCjY6gS3BPxoKQUvKN8RoZA17D0nQo9yho',
    appId: '1:666229050287:web:7e37ba6801eec835fd3d5a',
    messagingSenderId: '666229050287',
    projectId: 'mealsmission-822be',
    authDomain: 'mealsmission-822be.firebaseapp.com',
    storageBucket: 'mealsmission-822be.appspot.com',
    measurementId: 'G-BKM4XNMR5L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ6RIVzKdrlWrVVVvPsYdNvSXPrfR-RN0',
    appId: '1:666229050287:android:1fed4e7199a8c384fd3d5a',
    messagingSenderId: '666229050287',
    projectId: 'mealsmission-822be',
    storageBucket: 'mealsmission-822be.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWQuobebfseOxNC2JJL07s4GTdZsdBlt8',
    appId: '1:666229050287:ios:3569da8356ed1175fd3d5a',
    messagingSenderId: '666229050287',
    projectId: 'mealsmission-822be',
    storageBucket: 'mealsmission-822be.appspot.com',
    iosClientId: '666229050287-qr3svqc1kmvbuhm4fehrh09hilov0sqc.apps.googleusercontent.com',
    iosBundleId: 'com.example.mealsmission',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWQuobebfseOxNC2JJL07s4GTdZsdBlt8',
    appId: '1:666229050287:ios:3569da8356ed1175fd3d5a',
    messagingSenderId: '666229050287',
    projectId: 'mealsmission-822be',
    storageBucket: 'mealsmission-822be.appspot.com',
    iosClientId: '666229050287-qr3svqc1kmvbuhm4fehrh09hilov0sqc.apps.googleusercontent.com',
    iosBundleId: 'com.example.mealsmission',
  );
}
