import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/view/page_builder.dart';
import 'package:yazilar/config/config.dart' as conf;

import 'core/service/service.dart';

Future<void> main() async {
  await initApp();
  runApp(
    BlocProvider(
      create: (context) => CubitController(
        service: Service(Dio(BaseOptions(baseUrl: conf.baseUrl))),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   fontFamily: "Trebuchet MS",
        // ),
        home: const MyApp(),
        theme: ThemeData(
          primaryColor: Colors.lightBlue[800],
          primarySwatch: Colors.blue,
          fontFamily: "Trebuchet MS",
          textTheme: AppTheme.appTextTheme,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConfig.screenWidth = MediaQuery.of(context).size.width;
    AppConfig.screenHeight = MediaQuery.of(context).size.height;
    return const PageBuilder();
  }
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
  HttpOverrides.global = MyHttpOverrides();
  _getDeviceId();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
