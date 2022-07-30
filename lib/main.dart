import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/local_db/hive_controller.dart';
import 'package:yazilar/view/filter_screen.dart';
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
  await _getDeviceId();

  //initialize scroll controller
  Session.controller = ScrollController();
  //init hive
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  //open box
  await Hive.openBox<Article>('articles');
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// class Initializer extends StatefulWidget {
//   final Function onInit;
//   final Widget child;
//   final BuildContext context;

//   const Initializer(
//       {super.key,
//       required this.onInit,
//       required this.child,
//       required this.context});
//   @override
//   State<Initializer> createState() => _InitializerState();
// }

// class _InitializerState extends State<Initializer> {
//   @override
//   void initState() {
//     widget.onInit;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
