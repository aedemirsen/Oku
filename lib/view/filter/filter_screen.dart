import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:yazilar/utility/toast.dart';
import 'package:yazilar/view/custom_widgets/custom_button.dart';
import 'package:yazilar/view/filter/author.dart';
import 'package:yazilar/view/filter/category.dart';
import 'package:yazilar/view/filter/group.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({Key? key}) : super(key: key);
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
      centerTitle: true,
      foregroundColor: Colors.black,
      backgroundColor: conf.backgroundColor,
      title: Text(
        conf.filterScreenTitle,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  filterScreen(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        categoryButton(context),
        const Divider(),
        groupButton(context),
        const Divider(),
        authorButton(context),
        const Divider(),
        const SizedBox(
          height: 20,
        ),
        const Spacer(),
        //button
        filterButton(context),
        const SizedBox(
          height: 20,
        ),
        //clean all filters
        cleanFiltersButton(context),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  SizedBox groupButton(BuildContext context) {
    return SizedBox(
      //height: conf.filterElementHeight,
      width: conf.AppConfig.screenWidth,
      child: TextButton(
        onPressed: () {
          PageRouter.changePageWithAnimation(
              context, const Group(), PageRouter.rightToLeft);
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: conf.elementTextLeftInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conf.groupText,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: context
                        .watch<CubitController>()
                        .selectedGroups
                        .map(
                          (e) => Container(
                            constraints: BoxConstraints(
                              maxWidth: conf.AppConfig.screenWidth - 100,
                            ),
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                ],
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
      //height: conf.filterElementHeight,
      width: conf.AppConfig.screenWidth,
      child: TextButton(
        onPressed: () {
          PageRouter.changePageWithAnimation(
              context, const Category(), PageRouter.rightToLeft);
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: conf.elementTextLeftInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conf.categoryText,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: context
                        .watch<CubitController>()
                        .selectedCategories
                        .map(
                          (e) => Container(
                            constraints: BoxConstraints(
                              maxWidth: conf.AppConfig.screenWidth - 100,
                            ),
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                ],
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

  SizedBox authorButton(BuildContext context) {
    return SizedBox(
      //height: conf.filterElementHeight,
      width: conf.AppConfig.screenWidth,
      child: TextButton(
        onPressed: () {
          PageRouter.changePageWithAnimation(
              context, const Author(), PageRouter.rightToLeft);
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: conf.elementTextLeftInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conf.authorText,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: context
                        .watch<CubitController>()
                        .selectedAuthors
                        .map(
                          (e) => Container(
                            constraints: BoxConstraints(
                              maxWidth: conf.AppConfig.screenWidth - 100,
                            ),
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                ],
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
                  context.read<CubitController>().selectedGroups.isNotEmpty ||
                  context.read<CubitController>().selectedAuthors.isNotEmpty
              ? context.read<CubitController>().resetAndSearch()
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
            context.read<CubitController>().resetAndSearch();
          }
          showToastMessage(conf.filterCleanedText);
          Navigator.pop(context);
        },
      ),
    );
  }
}
