import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static String appTitle = "Yazılar";
  static double screenWidth = -1, screenHeight = -1;
}

class AppTheme {
  static TextTheme appTextTheme = const TextTheme(
    //app title
    headline1: TextStyle(fontSize: 40, color: Colors.black),
    //category - date
    headline2: TextStyle(fontSize: 15, color: Colors.black),
    //record title
    headline3: TextStyle(fontSize: 25, color: Colors.black),
    //body
    headline4: TextStyle(fontSize: 16, color: Colors.black),
  );
}

const double mainFrameInset = 20;
const IconData searchIcon = Icons.search;
const IconData orderBy = Icons.sort;
const IconData filterIcon = CupertinoIcons.slider_horizontal_3;

//filter screen
final double filterScreenWidth = (AppConfig.screenWidth) * 0.7;
final double filterScreenHeight = (AppConfig.screenHeight) * 0.5;
const double filtersHeaderHeight = 50;
const double filterButtonHeight = 50;
const double filteScreenRadius = 20;
final Color filterScreenBackgroundColor = Colors.transparent.withOpacity(0.6);

//Records
const double elevation = 3;
const double firstRecordHeight = 270;
const double recordsHeight = 140;
const double cardRadius = 15;
const double backIconSize = 40;
const IconData backIcon = Icons.arrow_back;
//favorite icon
const IconData favEnabledIcon = Icons.favorite;
const IconData favDisabledIcon = Icons.favorite_border_outlined;
const Color favColor = Colors.red;
const double favIconSize = 40;
//share icon
const IconData shareIcon = Icons.share;
const Color shareIconColor = Colors.black;
const double shareIconSize = 40;
