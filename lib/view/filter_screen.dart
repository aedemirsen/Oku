import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: filterScreen(context),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Center filterScreen(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Divider(),
          categoryButton(context),
          const Divider(),
          groupButton(context),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          //button
          filterButton(),
        ],
      ),
    );
  }

  SizedBox groupButton(BuildContext context) {
    return SizedBox(
      height: conf.filterElementHeight,
      width: conf.AppConfig.screenWidth,
      child: TextButton(
        onPressed: () {
          PageRouter.changePageWithAnimation(
            context,
            const Group(title: conf.groupTitle),
            PageRouter.leftToRight,
          );
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: conf.elementTextLeftInset),
              child: Text(
                conf.groupText,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: conf.elementTextLeftInset),
              child: conf.forwardIcon,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox categoryButton(BuildContext context) {
    return SizedBox(
      height: conf.filterElementHeight,
      width: conf.AppConfig.screenWidth,
      child: TextButton(
        onPressed: () {
          PageRouter.changePageWithAnimation(
            context,
            const Category(title: conf.categoryTitle),
            PageRouter.leftToRight,
          );
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: conf.elementTextLeftInset),
              child: Text(
                conf.categoryText,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: conf.elementTextLeftInset),
              child: conf.forwardIcon,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox filterButton() {
    return SizedBox(
      height: conf.filterButtonHeight,
      width: conf.filterScreenWidth,
      child: conf.AppConfig.device == 'ios'
          ? CupertinoButton(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: conf.filterButtonColor,
              child: const Text(conf.filterScreenTitle),
              onPressed: () {},
            )
          : ElevatedButton(
              child: const Text(conf.filterScreenTitle),
              onPressed: () {},
            ),
    );
  }
}

class Category extends StatelessWidget {
  const Category({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CubitController>().categories;
    return Scaffold(
      appBar: appBar(context),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
              height: 50,
              width: conf.AppConfig.screenWidth,
              child: TextButton(
                onPressed: (() {
                  context
                      .read<CubitController>()
                      .changeSelectedCategory(categories.elementAt(index));
                  Navigator.pop(context);
                }),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    categories.elementAt(index) == ''
                        ? '[Kategori Yok]'
                        : categories.elementAt(index),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

class Group extends StatelessWidget {
  const Group({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<CubitController>().groups;
    return Scaffold(
      appBar: appBar(context),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
              height: 50,
              width: conf.AppConfig.screenWidth,
              child: TextButton(
                onPressed: (() {}),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    groups.elementAt(index) == ''
                        ? '[Gruplandırılmamış]'
                        : groups.elementAt(index),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
