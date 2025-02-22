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
    apiKey: 'AIzaSyCxTniBHXdlQiHFGZPJPogYix0N_-t4foY',
    appId: '1:938137434612:web:396c0ee8b40ca0848aa1a1',
    messagingSenderId: '938137434612',
    projectId: 'train-8d40c',
    authDomain: 'train-8d40c.firebaseapp.com',
    storageBucket: 'train-8d40c.firebasestorage.app',
    measurementId: 'G-BK0JM4ERZY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUTLpgDkgSwMQhH72W2wOz47MmOZ80_ZI',
    appId: '1:938137434612:android:37ffb017ddfe2c818aa1a1',
    messagingSenderId: '938137434612',
    projectId: 'train-8d40c',
    storageBucket: 'train-8d40c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbNEnWdp7AXJKHnnMxz_VmE4PPXiYJ4ww',
    appId: '1:938137434612:ios:2c600546ed36d60f8aa1a1',
    messagingSenderId: '938137434612',
    projectId: 'train-8d40c',
    storageBucket: 'train-8d40c.firebasestorage.app',
    iosBundleId: 'com.example.githubapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbNEnWdp7AXJKHnnMxz_VmE4PPXiYJ4ww',
    appId: '1:938137434612:ios:2c600546ed36d60f8aa1a1',
    messagingSenderId: '938137434612',
    projectId: 'train-8d40c',
    storageBucket: 'train-8d40c.firebasestorage.app',
    iosBundleId: 'com.example.githubapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCxTniBHXdlQiHFGZPJPogYix0N_-t4foY',
    appId: '1:938137434612:web:dcebb8e3a5ba13998aa1a1',
    messagingSenderId: '938137434612',
    projectId: 'train-8d40c',
    authDomain: 'train-8d40c.firebaseapp.com',
    storageBucket: 'train-8d40c.firebasestorage.app',
    measurementId: 'G-MGDL370795',
  );


}