import 'package:flutter/material.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/view/settings.dart';
import 'package:yazilar/view/home_page.dart';
import 'package:yazilar/view/my_library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;

class PageBuilder extends StatefulWidget {
  const PageBuilder({Key? key}) : super(key: key);

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  late final List pages;

  @override
  void initState() {
    pages = [
      const HomePage(
        title: conf.appTitle,
      ),
      const MyLibrary(
        title: conf.libTitle,
      ),
      const Settings(
        title: conf.settingsTitle,
      ),
    ];
    //get first 15 data from database and insert into local database for caching
    context.read<CubitController>().getRecords(
        conf.orderParam, 'desc', null, conf.AppConfig.requestedDataQuantity);
    //get all categories and groups
    context.read<CubitController>().getCategories();
    context.read<CubitController>().getGroups();
    super.initState();
  }

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
