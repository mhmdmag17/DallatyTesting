import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBh1EJocTgYlqax5V-yS9IMtCT7EhM3H28',
    appId: '1:980090133126:android:f830f61defed69bb0d0f07',
    messagingSenderId: '980090133126',
    projectId: 'dalty-2fc70',
    storageBucket: 'dalty-2fc70.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxqGc-P5IfUF1cv_GuIiRrbqOo5n70H10',
    appId: '1:980090133126:ios:9c80e8f2977e41730d0f07',
    messagingSenderId: '980090133126',
    projectId: 'dalty-2fc70',
    storageBucket: 'dalty-2fc70.firebasestorage.app',
    iosBundleId: 'com.ebroker.wrteam',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCRP5hnHcSB_Ddnih5xJ6S609uHBo_Bw9c',
    appId: '1:980090133126:web:801d745ee311d9780d0f07',
    messagingSenderId: '980090133126',
    projectId: 'dalty-2fc70',
    authDomain: 'dalty-2fc70.firebaseapp.com',
    storageBucket: 'dalty-2fc70.firebasestorage.app',
    measurementId: 'G-CF44KBE709',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxqGc-P5IfUF1cv_GuIiRrbqOo5n70H10',
    appId: '1:980090133126:ios:65d6a971715919210d0f07',
    messagingSenderId: '980090133126',
    projectId: 'dalty-2fc70',
    storageBucket: 'dalty-2fc70.firebasestorage.app',
    iosBundleId: 'com.DaltyGroup.Dalty',
  );

}