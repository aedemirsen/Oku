import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/cubit/cubit_controller.dart';

import 'view/home_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => CubitController(),
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
    return HomePage(title: AppConfig.appTitle);
  }
}

void initApp() {}
