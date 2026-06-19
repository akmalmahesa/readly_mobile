// Android is configured from google-services.json (project "ngfs-3fe77").
// iOS/macOS/web are still placeholders — fill them in (or run
// `flutterfire configure`) if you need those platforms.
//
// Note: Firebase plugins (firebase_core / firebase_auth / cloud_firestore)
// do not support Windows or Linux desktop targets — run this app on
// Android, iOS, macOS, or web (Chrome).

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform. '
          'Run `flutterfire configure` to add support for it.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAg9wEoCPUZGzU0MYuyVgwVKCDjjbZ9msE',
    appId: '1:268715048593:web:dbab56651d791132048930',
    messagingSenderId: '268715048593',
    projectId: 'ngfs-3fe77',
    authDomain: 'ngfs-3fe77.firebaseapp.com',
    storageBucket: 'ngfs-3fe77.firebasestorage.app',
    measurementId: 'G-JP81GLLK51',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBN_v6NTSFCJp7nQ0ypc-gMQQ6U_93J948',
    appId: '1:268715048593:android:0c1dfd5f9ef906ca048930',
    messagingSenderId: '268715048593',
    projectId: 'ngfs-3fe77',
    storageBucket: 'ngfs-3fe77.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'REPLACE_WITH_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.readly',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_MACOS_APP_ID',
    messagingSenderId: 'REPLACE_WITH_SENDER_ID',
    projectId: 'REPLACE_WITH_PROJECT_ID',
    storageBucket: 'REPLACE_WITH_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.readly',
  );
}
