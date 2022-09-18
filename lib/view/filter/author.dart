import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:Oku/config/config.dart' as conf;

import '../custom_widgets/custom_button.dart';

class Author extends StatefulWidget {
  const Author({Key? key}) : super(key: key);

  static int id = 3;

  @override
  State<Author> createState() => _AuthorState();
}

class _AuthorState extends State<Author> {
  @override
  void initState() {
    //get all categories
    context.read<CubitController>().getAuthors();
    //set current page id
    context.read<CubitController>().changeCurrentPage(Author.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      appBar: appBar(context),
      body: context.watch<CubitController>().authorsLoading
          ? const Center(
              child: conf.indicator,
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: context.watch<CubitController>().authors.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                context.watch<CubitController>().authors.length,
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
                                          .addSelectedAuthors(context
                                              .read<CubitController>()
                                              .authors
                                              .elementAt(index));
                                    }),
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            context
                                                        .watch<
                                                            CubitController>()
                                                        .authors
                                                        .elementAt(index) ==
                                                    ''
                                                ? '[Yazar Yok]'
                                                : context
                                                    .watch<CubitController>()
                                                    .authors
                                                    .elementAt(index),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                        const Spacer(),
                                        context
                                                .watch<CubitController>()
                                                .selectedAuthors
                                                .contains(context
                                                    .watch<CubitController>()
                                                    .authors
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
                            bottom: 50,
                            top: 20,
                            left: 20,
                            right: 20,
                          ),
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
                                context.read<CubitController>().clearAuthors();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : !context.read<CubitController>().isConnected &&
                          context.read<CubitController>().authors.isEmpty
                      ? const Center(
                          child: conf.disconnected,
                        )
                      : Center(
                          child: Text(
                            'Yazar mevcut değil!',
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
      //backgroundColor: conf.backgroundColor,
      title: Text(
        conf.authorTitle,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
