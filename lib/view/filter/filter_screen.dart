import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/utility/toast.dart';
import 'package:yazilar/view/custom_widgets/custom_button.dart';
import 'package:yazilar/view/filter/category.dart';
import 'package:yazilar/view/filter/group.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({Key? key}) : super(key: key);
  static const String route = '/filter';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      appBar: appBar(context),
      body: filterScreen(context),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: conf.backgroundColor,
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
        borderColor: Colors.black,
        color: conf.backgroundColor,
        callback: () {
          context.read<CubitController>().selectedCategories.isNotEmpty ||
                  context.read<CubitController>().selectedGroups.isNotEmpty
              ? context.read<CubitController>().searchByFilter()
              : null;
          Navigator.pop(context);
        },
        child: const Text(
          conf.filterScreenTitle,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  SizedBox cleanFiltersButton(BuildContext context) {
    return SizedBox(
      height: conf.filterButtonHeight,
      width: conf.filterScreenWidth,
      child: CustomButton(
        borderColor: Colors.black,
        color: conf.backgroundColor,
        child: const Text(
          conf.cleanAllFilters,
          style: TextStyle(color: Colors.black),
        ),
        callback: () {
          if (context.read<CubitController>().selectedCategories.isNotEmpty ||
              context.read<CubitController>().selectedGroups.isNotEmpty) {
            context.read<CubitController>().clearCategories();
            context.read<CubitController>().clearGroups();
            context.read<CubitController>().searchByFilter();
          }
          showToastMessage(conf.filterCleanedText);
          Navigator.pop(context);
        },
      ),
    );
  }
}
