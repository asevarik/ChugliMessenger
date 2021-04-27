// //notifications goes here
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class PushNotificationService {
//   static final screename = "PushNotifications";
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//   _getToken() {
//     _fcm.getToken().then((value) {
//       print("$value device token");
//     });
//   }

//   Future initialise() async {
//     if (Platform.isIOS) {
//       _fcm.requestNotificationPermissions(IosNotificationSettings());
//     }

//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//     );
//   }
// }
