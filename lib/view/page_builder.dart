import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/view/settings/settings_page.dart';
import 'package:yazilar/view/home_page.dart';
import 'package:yazilar/view/library/my_library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;

class PageBuilder extends StatefulWidget {
  const PageBuilder({Key? key}) : super(key: key);

  static const String route = '/';

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  late final List pages;

  @override
  void initState() {
    pages = [
      const HomePage(),
      const MyLibrary(
        title: conf.libTitle,
      ),
      const Settings(
        title: conf.settingsTitle,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (AppConfig.screenWidth == -1 || AppConfig.screenHeight == -1) {
      AppConfig.screenWidth = MediaQuery.of(context).size.width;
      AppConfig.screenHeight = MediaQuery.of(context).size.height;
    }
    //init toast
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      body: pages[context.watch<CubitController>().pageIndex],
      bottomNavigationBar: navigationBar(context),
    );
  }

  BottomNavigationBar navigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: context.watch<CubitController>().pageIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(conf.homeIcon),
          label: conf.homePageLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(conf.libIcon),
          label: conf.libPageLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(conf.settingsIcon),
          label: conf.settingsPageLabel,
        ),
      ],
      onTap: (index) {
        context.read<CubitController>().changePage(index);
      },
      fixedColor: Colors.black,
    );
  }
}
