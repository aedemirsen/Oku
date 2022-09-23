import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Oku/config/config.dart';
import 'package:Oku/core/caching/hive_controller.dart';
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:Oku/core/model/article.dart';
import 'package:Oku/core/network/internet_waiting.dart';
import 'package:Oku/firebase_options.dart';
import 'package:Oku/utility/build_color.dart';
import 'package:Oku/view/page_builder.dart';
import 'package:Oku/config/config.dart' as conf;

import 'core/service/service.dart';

Future<void> main() async {
  Service service = Service(Dio(BaseOptions(baseUrl: conf.baseUrl)));
  //initialize some configurations
  await initApp(service);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    BlocProvider(
      create: (context) => CubitController(
        service: service,
        hive: HiveController(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: conf.AppConfig.primaryColor,
          primarySwatch: buildMaterialColor(
            conf.AppConfig.primaryColor,
          ),
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
  if (!kIsWeb) {
    if (Platform.isIOS) {
      conf.AppConfig.device = "ios";
    } else if (Platform.isAndroid) {
      conf.AppConfig.device = "android";
    }
  } else {
    conf.AppConfig.device = 'web';
  }
}

Future<void> initApp(Service service) async {
  await Future.delayed(const Duration(seconds: 2));
  WidgetsFlutterBinding.ensureInitialized();

  ///set device
  setDevice();

  if (!kIsWeb) {
    //init firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
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
  }

  //Certificate problemi çözülmeli
  //HttpOverrides.global = MyHttpOverrides();

  ///initialize scroll controller
  Session.controller = ScrollController(keepScrollOffset: true);
  Session.controllerTitle = ScrollController(keepScrollOffset: true);

  ///init hive - open box(table) - for local caching and library
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>('articles');
  await Hive.openBox<Object>('constants');
  await Hive.openBox<String>('readArticles');

  conf.AppConfig.deviceId = HiveController().getDeviceId();
}
