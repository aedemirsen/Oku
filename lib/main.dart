import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/core/model/user.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/firebase_options.dart';
import 'package:yazilar/caching/hive_controller.dart';
import 'package:yazilar/view/filter/category.dart';
import 'package:yazilar/view/filter/filter_screen.dart';
import 'package:yazilar/view/filter/group.dart';
import 'package:yazilar/view/page_builder.dart';
import 'package:yazilar/config/config.dart' as conf;

import 'core/service/service.dart';

///push notification options
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message ${message.messageId}');
//   print(message.data);
//   flutterLocalNotificationsPlugin.show(
//     message.data.hashCode,
//     message.data['title'],
//     message.data['body'],
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//       ),
//     ),
//   );
// }

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   importance: Importance.high,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> main() async {
  //initialize some configurations
  await initApp();

  runApp(
    BlocProvider(
      create: (context) => CubitController(
        service: Service(Dio(BaseOptions(baseUrl: conf.baseUrl))),
        hive: HiveController(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.lightBlue[800],
          primarySwatch: Colors.blue,
          fontFamily: "Trebuchet MS",
          textTheme: AppTheme.appTextTheme,
        ),
        initialRoute: PageBuilder.route,
        routes: {
          PageBuilder.route: (context) => const PageBuilder(),
          FilterScreen.route: (context) => const FilterScreen(),
          Category.route: (context) => const Category(),
          Group.route: (context) => const Group(),
        },
      ),
    ),
  );
}

Future<String> _getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    conf.AppConfig.device = "ios";
    return iosDeviceInfo.identifierForVendor ?? "";
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    conf.AppConfig.device = "android";
    return androidDeviceInfo.id ?? "";
  }
  return "";
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Certificate problemi çözülmeli
  //HttpOverrides.global = MyHttpOverrides();

  ///Get device id, whether it is android or ios
  AppConfig.deviceId = await _getDeviceId();

  ///initialize scroll controller
  Session.controller = ScrollController();

  ///init hive - open box(table) - for local caching and library
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>('articles');
  await Hive.openBox<double>('constants');

  //initialize firebase for cloud messaging - notifications
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  //subscribe to topic
  // await messaging.subscribeToTopic('articles');

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   //TODO
  //   //uygulama açıkken notification geldiğinde yapılması gereken.
  // });

  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // switch (AppConfig.device) {
  //   case 'android':
  //     await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //         ?.createNotificationChannel(channel);
  //     break;
  //   case 'ios':
  //     await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //             IOSFlutterLocalNotificationsPlugin>()
  //         ?.requestPermissions(
  //           alert: true,
  //           badge: true,
  //           sound: true,
  //         );
  // }

  // var initSettingsAndroid =
  //     const AndroidInitializationSettings('@mipmap/ic_launcher');

  // var initSettingsIos = const IOSInitializationSettings(
  //   requestSoundPermission: true,
  //   requestBadgePermission: true,
  //   requestAlertPermission: true,
  // );

  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initSettingsAndroid,
  //   iOS: initSettingsIos,
  // );

  // flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           icon: android.smallIcon,
  //         ),
  //       ),
  //     );
  //   }
  // });
}
