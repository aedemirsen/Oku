import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/firebase_options.dart';
import 'package:yazilar/local_db/hive_controller.dart';
import 'package:yazilar/view/filter/category.dart';
import 'package:yazilar/view/filter/filter_screen.dart';
import 'package:yazilar/view/filter/group.dart';
import 'package:yazilar/view/page_builder.dart';
import 'package:yazilar/config/config.dart' as conf;

import 'core/service/service.dart';

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
    return androidDeviceInfo.androidId ?? "";
  }
  return "";
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Certificate problemi çözülmeli
  //HttpOverrides.global = MyHttpOverrides();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );

  ///init firebase
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //subscribe to articles topic for firebase messaging(push notifications)
  //when ever a new article is added to db, every user will receive a push notification
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FirebaseMessaging.instance.subscribeToTopic('articles');

  ///Get device id, whether it is android or ios
  await _getDeviceId();

  ///initialize scroll controller
  Session.controller = ScrollController();

  ///init hive - open box(table)
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>('articles');
}

void Notify() async {
  // local notification
  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 10,
    channelKey: 'basic_channel',
    title: 'Simple Notification',
    body: 'Simple body',
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}
