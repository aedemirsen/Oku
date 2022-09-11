import 'package:flutter/material.dart';
import 'package:Oku/config/config.dart' as conf;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:Oku/view/library/favorites.dart';
import 'package:Oku/view/library/read_articles.dart';

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
    //get read articles from local db
    context.read<CubitController>().getAllReadArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: conf.backgroundColor,
        appBar: appBar(context),
        body: const TabBarView(
          children: [
            FavoritesPage(),
            ReadArticlesPage(),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      // backgroundColor: conf.backgroundColor,
      title: Center(
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      bottom: TabBar(
        indicatorColor: Colors.black,
        tabs: [
          Tab(
              icon: Text(
            'Favorilerim',
            style: Theme.of(context).textTheme.headline5,
          )),
          Tab(
              icon: Text(
            'Okuduklarım',
            style: Theme.of(context).textTheme.headline5,
          )),
        ],
      ),
    );
  }
}
