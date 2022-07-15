import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static double screenWidth = -1, screenHeight = -1;
  static String device = '';
  static String deviceId = '';
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
    //filter elements text
    headline5: TextStyle(fontSize: 20, color: Colors.black),
  );
}

//AppBar titles
const String appTitle = "Yazılar";
const String libTitle = "Kitaplığım";
const String settingsTitle = "Ayarlar";
const String filterScreenTitle = 'Filtrele';
const String categoryTitle = 'Kategoriler';
const String groupTitle = 'Seriler';

//icons
const IconData homeIcon = Icons.home;
const IconData libIcon = Icons.book;
const IconData settingsIcon = Icons.settings;
const Icon sortIcon = Icon(
  Icons.sort,
  color: Colors.black,
);
const Icon filterIcon = Icon(
  CupertinoIcons.slider_horizontal_3,
  color: Colors.black,
);
const Icon searchIcon = Icon(
  Icons.search,
  color: Colors.black,
);

final Color backgroundColor = Colors.grey.shade200;
const String sortText = 'Tarihe göre sırala';
const String homePageLabel = 'Ana Sayfa';
const String libPageLabel = 'Kitaplığım';
const String settingsPageLabel = 'Ayarlar';
const double mainFrameInset = 20;

//filter screen
const String categoryText = 'Kategori';
const String groupText = 'Seri';
const Color filterButtonColor = Colors.blue;
final double filterScreenWidth = (AppConfig.screenWidth) * 0.9;
final double filterScreenHeight = (AppConfig.screenHeight) * 0.5;
const double filtersHeaderHeight = 50;
const double filterButtonHeight = 50;
const double filterElementHeight = 50;
const double filterScreenRadius = 20;
final Color filterScreenBackgroundColor = Colors.transparent.withOpacity(0.6);
final double elementTextLeftInset = AppConfig.screenWidth * 0.1 / 2;
const Icon forwardIcon = Icon(Icons.arrow_forward_ios, color: Colors.black);

//Records
const double elevation = 3;
const double firstRecordHeight = 270;
const double recordsHeight = 140;
const double cardRadius = 15;
const double backIconSize = 40;
const IconData backIcon = Icons.arrow_back;
const Color groupBadgeColor = Colors.blueGrey;
const Color categoryBadgeColor = Colors.amber;
//favorite icon
const IconData favEnabledIcon = Icons.favorite;
const IconData favDisabledIcon = Icons.favorite_border_outlined;
const Color favColor = Colors.red;
const double favIconSize = 40;
//share icon
const IconData shareIcon = Icons.share;
const Color shareIconColor = Colors.black;
const double shareIconSize = 40;
