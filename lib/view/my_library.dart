import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/view/custom_widgets/article_view.dart';

class MyLibrary extends StatelessWidget {
  const MyLibrary({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(
          conf.mainFrameInset,
        ),
        child: context.watch<CubitController>().favorites.isEmpty
            ? Center(
                child: Text(
                  'Kitaplık Boş!',
                  style: Theme.of(context).textTheme.headline3,
                ),
              )
            : ListView.builder(
                //controller: conf.Session.controller,
                itemCount: context.watch<CubitController>().favorites.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          (context.watch<CubitController>().favorites.length -
                                      1 ==
                                  index
                              ? 15.0
                              : 0),
                    ),
                    child: ArticleView(
                      index,
                      library: true,
                      article: context.watch<CubitController>().favorites[
                          context
                              .watch<CubitController>()
                              .favorites
                              .keys
                              .elementAt(index)]!,
                      elevation: conf.elevation,
                    ),
                  );
                }),
              ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
