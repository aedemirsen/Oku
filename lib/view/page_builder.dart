import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/core/network/connectivity_change.dart';
import 'package:yazilar/utility/when_not_zero.dart';
import 'package:yazilar/view/settings/settings_page.dart';
import 'package:yazilar/view/home_page.dart';
import 'package:yazilar/view/library/my_library.dart';
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
    NetworkChangeManager().checkNetwork().then((value) {
      context.read<CubitController>().updateOnConnectivity(value);
    });
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
    //init toast
    ToastContext().init(context);
    return FutureBuilder(
      future: whenNotZero(
        Stream<Size>.periodic(
          const Duration(milliseconds: 50),
          (x) => MediaQuery.of(context).size,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if ((snapshot.data as Size).height > 0 &&
              (snapshot.data as Size).width > 0) {
            AppConfig.screenWidth = MediaQuery.of(context).size.width;
            AppConfig.screenHeight = MediaQuery.of(context).size.height;
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: conf.backgroundColor,
                  body: pages[context.watch<CubitController>().pageIndex],
                  bottomNavigationBar: navigationBar(context),
                ),
                context.watch<CubitController>().readArticleLoading
                    ? Container(
                        color: Colors.transparent.withOpacity(0.4),
                        child: const Center(
                          child: conf.indicator,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          }
        }
        return const Center(
          child: conf.indicator,
        );
      },
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
