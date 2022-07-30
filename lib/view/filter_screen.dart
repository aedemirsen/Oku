import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/utility/snackbar.dart';
import 'package:yazilar/view/custom_widgets/custom_button.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({Key? key}) : super(key: key);
  static const String route = '/filter';
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
        conf.filterScreenTitle,
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
          filterButton(context),
          const SizedBox(
            height: 20,
          ),
          //clean all filters
          cleanFiltersButton(context),
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
          Navigator.pushNamed(context, Group.route);
          // PageRouter.changePageWithAnimation(
          //   context,
          //   const Group(),
          //   PageRouter.leftToRight,
          // );
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
          Navigator.pushNamed(context, Category.route);
          // PageRouter.changePageWithAnimation(
          //   context,
          //   const Category(),
          //   PageRouter.leftToRight,
          // );
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

  SizedBox filterButton(BuildContext context) {
    return SizedBox(
      height: conf.filterButtonHeight,
      width: conf.filterScreenWidth,
      child: CustomButton(
        title: conf.filterScreenTitle,
        callback: () {
          context.read<CubitController>().searchByFilter();
          Navigator.pop(context);
        },
      ),
    );
  }

  SizedBox cleanFiltersButton(BuildContext context) {
    return SizedBox(
      height: conf.filterButtonHeight,
      width: conf.filterScreenWidth,
      child: CustomButton(
        title: conf.cleanAllFilters,
        callback: () {
          context.read<CubitController>().changeSelectedCategory(null);
          context.read<CubitController>().changeSelectedGroup(null);
          showSnackBar(context, conf.filterCleanedText, 'Tamam');
        },
      ),
    );
  }
}

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  static const String route = '/category';

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    //get all categories
    context.read<CubitController>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CubitController>().categories;
    return Scaffold(
      appBar: appBar(context),
      body: context.watch<CubitController>().categoriesLoading
          ? const Center(
              child: SizedBox(
                height: 60,
                width: 60,
                child: conf.indicator,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: SizedBox(
                            height: conf.filterElementHeight,
                            width: conf.AppConfig.screenWidth,
                            child: TextButton(
                              onPressed: (() {
                                context
                                    .read<CubitController>()
                                    .changeSelectedCategory(
                                        categories.elementAt(index));
                                // Navigator.popUntil(
                                //     context, ModalRoute.withName(PageBuilder.route));
                                Navigator.pop(context);
                              }),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      categories.elementAt(index) == ''
                                          ? '[Kategori Yok]'
                                          : categories.elementAt(index),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                  const Spacer(),
                                  categories.elementAt(index) ==
                                          context
                                              .watch<CubitController>()
                                              .selectedCategory
                                      ? conf.checkIcon
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50, top: 20, left: 20, right: 20),
                    child: SizedBox(
                      width: conf.AppConfig.screenWidth,
                      height: conf.filterButtonHeight,
                      child: CustomButton(
                        title: conf.cleanFilter,
                        callback: () {
                          context
                              .read<CubitController>()
                              .changeSelectedCategory(null);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        conf.categoryTitle,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

class Group extends StatelessWidget {
  const Group({Key? key}) : super(key: key);

  static const String route = '/group';

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<CubitController>().groups;
    return Scaffold(
      appBar: appBar(context),
      body: context.watch<CubitController>().categoriesLoading
          ? const Center(
              child: SizedBox(
                height: 60,
                width: 60,
                child: conf.indicator,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            height: conf.filterElementHeight,
                            width: conf.AppConfig.screenWidth,
                            child: TextButton(
                              onPressed: (() {
                                context
                                    .read<CubitController>()
                                    .changeSelectedGroup(
                                        groups.elementAt(index));
                                Navigator.pop(context);
                              }),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      groups.elementAt(index) == ''
                                          ? '[Gruplandırılmamış]'
                                          : groups.elementAt(index),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                  const Spacer(),
                                  groups.elementAt(index) ==
                                          context
                                              .watch<CubitController>()
                                              .selectedGroup
                                      ? conf.checkIcon
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50, top: 20, left: 20, right: 20),
                    child: SizedBox(
                      width: conf.AppConfig.screenWidth,
                      height: conf.filterButtonHeight,
                      child: CustomButton(
                        title: conf.cleanFilter,
                        callback: () {
                          context
                              .read<CubitController>()
                              .changeSelectedGroup(null);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        conf.groupTitle,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
