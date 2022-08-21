import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/config/config.dart' as conf;

import '../custom_widgets/custom_button.dart';

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
    return Scaffold(
      backgroundColor: conf.backgroundColor,
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
              child: context.watch<CubitController>().categories.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: context
                                .watch<CubitController>()
                                .categories
                                .length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10,
                                ),
                                child: SizedBox(
                                  height: conf.filterElementHeight,
                                  width: conf.AppConfig.screenWidth,
                                  child: TextButton(
                                    onPressed: (() {
                                      context
                                          .read<CubitController>()
                                          .addSelectedCategories(context
                                              .read<CubitController>()
                                              .categories
                                              .elementAt(index));
                                      // Navigator.popUntil(
                                      //     context, ModalRoute.withName(PageBuilder.route));
                                      // Navigator.pop(context);
                                    }),
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            context
                                                        .watch<
                                                            CubitController>()
                                                        .categories
                                                        .elementAt(index) ==
                                                    ''
                                                ? '[Kategori Yok]'
                                                : context
                                                    .watch<CubitController>()
                                                    .categories
                                                    .elementAt(index),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                        const Spacer(),
                                        context
                                                .watch<CubitController>()
                                                .selectedCategories
                                                .contains(context
                                                    .watch<CubitController>()
                                                    .categories
                                                    .elementAt(index))
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
                              borderColor: Colors.black,
                              color: conf.backgroundColor,
                              child: const Text(
                                conf.cleanFilter,
                                style: TextStyle(color: Colors.black),
                              ),
                              callback: () {
                                context
                                    .read<CubitController>()
                                    .clearCategories();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'Kategori Mevcut Değil!',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
            ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      foregroundColor: Colors.black,
      backgroundColor: conf.backgroundColor,
      title: Text(
        conf.categoryTitle,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
