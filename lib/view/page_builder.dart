import 'package:flutter/material.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/view/settings.dart';
import 'package:yazilar/view/home_page.dart';
import 'package:yazilar/view/my_library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;

class PageBuilder extends StatelessWidget {
  const PageBuilder({Key? key}) : super(key: key);

  final pages = const [
    HomePage(
      title: conf.appTitle,
    ),
    MyLibrary(
      title: conf.libTitle,
    ),
    Settings(
      title: conf.settingsTitle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
