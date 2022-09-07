import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/caching/hive_controller.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/core/network/internet_waiting.dart';
import 'package:yazilar/firebase_options.dart';
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
        builder: (context, child) {
          return Column(
            children: [
              Expanded(child: child ?? const SizedBox.shrink()),
              const InternetWaiting(),
            ],
          );
        },
        home: const PageBuilder(),
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
  await Future.delayed(const Duration(seconds: 1));
  WidgetsFlutterBinding.ensureInitialized();

  //init firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //firebase messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  final token = await messaging.getToken();
  print(token);

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

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
}
