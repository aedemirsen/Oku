import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppConfig {
  static double screenWidth = -1, screenHeight = -1;
  static String device = '';
  static String deviceId = '';
  static const int requestedDataQuantity = 10;
  static const int titlesRequestedDataQuantity = 100;
  static Color primaryColor = const Color(0xff497a79);
  static String appName = '';
  static String packageName = '';
  static String version = '';
  static String buildNumber = '';
  static Uri appStore = Uri.parse('http://oku.bilgimeclisi.com');
  static Uri playStore = Uri.parse('http://oku.bilgimeclisi.com');
}

class Session {
  //Scroll Controller
  static ScrollController? controller;
  static ScrollController? controllerTitle;
}

class AppTheme {
  static TextTheme appTextTheme = const TextTheme(
    //opened article header
    headline1: TextStyle(
        fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
    //category - date
    headline2: TextStyle(fontSize: 15, color: Colors.black),
    //article title
    headline3: TextStyle(
        fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
    //body
    headline4: TextStyle(fontSize: 16, color: Colors.black),
    headline6: TextStyle(
        fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
    //filter elements text
    headline5: TextStyle(fontSize: 20, color: Colors.black),
    //flexible header
    subtitle1: TextStyle(
      fontSize: 30,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}

//api
//const String baseUrl = "http://10.0.2.2:8080/api"; //android emulator
//const String baseUrl = "http://192.168.1.9:8080/api";
//const String baseUrl = "http://localhost:8080/api";
const String baseUrl = "https://articles-service.vercel.app/api";
//website
final Uri url = Uri.parse('http://oku.bilgimeclisi.com');

//AppBar titles
const String appTitle = "Yazılar";
const String libTitle = "Kitaplığım";
const String settingsTitle = "Ayarlar";
const String filterScreenTitle = 'Filtrele';
const String categoryTitle = 'Kategoriler';
const String authorTitle = 'Yazarlar';
const String groupTitle = 'Seriler';
const String indexTitle = 'Fihrist';

//Progress indicator
const SizedBox indicator = SizedBox(
  height: 40,
  width: 40,
  child: CircularProgressIndicator(),
);

//icons
const IconData homeIcon = FontAwesomeIcons.house;
const IconData libIcon = FontAwesomeIcons.book;
const IconData settingsIcon = FontAwesomeIcons.gear;
const Icon disconnected = Icon(
  Icons.wifi_off,
  size: 50,
);
const FaIcon sort1_9 = FaIcon(
  FontAwesomeIcons.arrowDown19,
  color: Colors.black,
);
const FaIcon sort9_1 = FaIcon(
  FontAwesomeIcons.arrowDown91,
  color: Colors.black,
);
const FaIcon filterIcon = FaIcon(
  FontAwesomeIcons.filter,
  color: Colors.black,
);
const Icon searchIcon = Icon(
  FontAwesomeIcons.magnifyingGlass,
  color: Colors.black,
  size: 30,
);
const Icon searchIconOpened = Icon(
  FontAwesomeIcons.magnifyingGlass,
  color: Colors.black,
  size: 25,
);

final double searchBarWidth = AppConfig.screenWidth / 2;

const Icon closeIconOpened = Icon(
  FontAwesomeIcons.xmark,
  color: Colors.black,
  size: 30,
);

const Icon closeIcon = Icon(
  FontAwesomeIcons.xmark,
  color: Colors.black,
  size: 25,
);

const Icon dashIcon = Icon(
  FontAwesomeIcons.minus,
  color: Colors.black,
  size: 20,
);

final double appBarHeight = AppConfig.screenHeight / 6;
const double sortFilterHeight = 40;
//final Color backgroundColor = Colors.grey.shade300;
const Color backgroundColor = Color(0xffede7d8);
const Color cardColor = Color(0xfff2f2f0);
const String readListText = 'Okuma Listesi';
const String homePageLabel = 'Ana Sayfa';
const String libPageLabel = 'Kitaplığım';
const String settingsPageLabel = 'Ayarlar';
const String addedToFav = 'Yazı kitaplığa eklendi.';
const String addedToReadArticles = 'Yazı okunanlar listesine eklendi.';
const String removeFromFav = 'Yazı kitaplıktan çıkarıldı.';
const String removeFromReadArticles = 'Yazı okunanlar listesinden çıkarıldı.';
const String dontShowReadArticles =
    'Okunmuş yazılar ana sayfada gösterilmeyecek.';
const String showReadArticles = 'Okunmuş yazılar ana sayfada gösterilecek.';
const String clearReadArticles = 'Okunanlar listesini temizle';
final double mainFrameInset = AppConfig.screenWidth / 25;

const double bottomSheetElementHeight = 50;

//filter screen
const String categoryText = 'Kategori';
const String groupText = 'Seri';
const String authorText = 'Yazar';
const String cleanFilter = 'Filtreyi Temizle';
const String cleanAllFilters = 'Tüm Filtreleri Temizle';
const String filterCleanedText = 'Tüm Filtreler Temizlendi!';
const Color filterButtonColor = Colors.blue;
final double filterScreenWidth = (AppConfig.screenWidth) * 0.9;
final double filterScreenHeight = (AppConfig.screenHeight) * 0.5;
const double filterButtonHeight = 50;
const double filterElementHeight = 50;
const double filterScreenRadius = 20;
final Color filterScreenBackgroundColor = Colors.transparent.withOpacity(0.6);
final double elementTextLeftInset = AppConfig.screenWidth * 0.1 / 2;
const Icon forwardIcon = Icon(Icons.arrow_forward_ios, color: Colors.black);
final Icon checkIcon = Icon(
  Icons.check,
  color: AppConfig.primaryColor,
);

//Articles
const double elevation = 3;
const double radius = 10;
const double backIconSize = 30;
const IconData backIcon = Icons.arrow_back;
const Color groupBorderColor = Colors.blueGrey;
const Color categoryBorderColor = Colors.black;
const String signAsRead = 'Okundu Olarak İşaretle';
const String removeFromRead = 'Okunanlardan Kaldır';
const String alreadyRead = 'Okundu';
//font icon
const FaIcon fontIcon = FaIcon(
  FontAwesomeIcons.textHeight,
  color: Colors.black,
  size: 20,
);
//font icon
IconData font = FontAwesomeIcons.font;
//font icon sized
const double fontLarge = 50;
const double fontMedium = 40;
const double fontSmall = 30;
//selected font color
const Color selectedFontColor = Color.fromARGB(255, 33, 72, 243);
//default font color
const Color defaultFontColor = Colors.black;

//favorite icon
const IconData favEnabledIcon = Icons.favorite;
const IconData favDisabledIcon = Icons.favorite_border_outlined;
const Color favColor = Colors.red;
const double favIconSize = 30;
//share icon
const IconData shareIcon = Icons.share;
const Color shareIconColor = Colors.black;
const double shareIconSize = 30;
