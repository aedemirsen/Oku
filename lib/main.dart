import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/caching/hive_controller.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/core/network/internet_waiting.dart';
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
        builder: (context, child) {
          return Column(
            children: [
              Expanded(child: child ?? const SizedBox.shrink()),
              const InternetWaiting(),
            ],
          );
        },
        home: const PageBuilder(),
        // home: BlocBuilder<CubitController, AppState>(
        //   builder: (context, state) {
        //     return Stack(
        //       alignment: AlignmentDirectional.bottomCenter,
        //       children: [
        //         const PageBuilder(),
        //         state is ConnectivityFail
        //             ? Container(
        //                 height: 80,
        //                 color: Colors.red,
        //                 child: Text('İnternet Bağlantısı Bekleniyor'),
        //               )
        //             : const SizedBox.shrink(),
        //       ],
        //     );
        //   },
        // ),
      ),
    ),
  );
}

void setDevice() {
  if (Platform.isIOS) {
    conf.AppConfig.device = "ios";
  } else if (Platform.isAndroid) {
    conf.AppConfig.device = "android";
  }
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Certificate problemi çözülmeli
  //HttpOverrides.global = MyHttpOverrides();

  ///set device
  setDevice();

  ///initialize scroll controller
  Session.controller = ScrollController();
  Session.controllerTitle = ScrollController();

  ///init hive - open box(table) - for local caching and library
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>('articles');
  await Hive.openBox<Object>('constants');
  await Hive.openBox<String>('readArticles');

  conf.AppConfig.deviceId = HiveController().getDeviceId();

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
