import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/view/custom_widgets/article_view.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  void initState() {
    //get favorite articles from local db
    context.read<CubitController>().getAllFavoriteArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.all(
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
      backgroundColor: conf.backgroundColor,
      title: Center(
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
