import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not supported yet');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS is not supported yet');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  // TODO: Replace with your Firebase project configuration
  // Get this from Firebase Console > Project Settings > Your Apps > SDK setup and configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: '1:YOUR_PROJECT_NUMBER:android:YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'karteji-rt01',
    storageBucket: 'karteji-rt01.appspot.com',
  );
}
