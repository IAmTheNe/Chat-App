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
    apiKey: 'AIzaSyCxFpfGxjdMJMayj8FPjLS3bEvp78-yRD0',
    appId: '1:343779067277:android:b421a30985df509991a9c4',
    messagingSenderId: '343779067277',
    projectId: 'chatty-app-c401c',
    storageBucket: 'chatty-app-c401c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBIKj2NOGiDwY4v0nQPy2p5ini-9sLM4X0',
    appId: '1:343779067277:ios:ddae07f01eb12fb291a9c4',
    messagingSenderId: '343779067277',
    projectId: 'chatty-app-c401c',
    storageBucket: 'chatty-app-c401c.appspot.com',
    androidClientId: '343779067277-c8g9jnrfgv5jji5shso380eo924olg72.apps.googleusercontent.com',
    iosClientId: '343779067277-j1la5u38llqu5s3ip3gbdrgtes8gofus.apps.googleusercontent.com',
    iosBundleId: 'com.thyx.chatapp.chatApp',
  );
}
