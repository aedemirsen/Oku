import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/view/custom_widgets/article_view.dart';
import 'package:yazilar/view/custom_widgets/filter_sort_sliver_header.dart';
import 'custom_widgets/skeleton_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //get first 15 data from server to show in listview
    if (context.read<CubitController>().articles.isEmpty) {
      context.read<CubitController>().getArticles();
    }
    //get favorite articles from local db
    context.read<CubitController>().getAllFavoriteArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      body: BlocBuilder<CubitController, AppState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  controller: conf.Session.controller,
                  slivers: <Widget>[
                    sliverAppBar(context),
                    SliverPersistentHeader(
                      delegate: FilterSortSliverHeader(),
                      pinned: true,
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    sliverList(context),
                  ],
                ),
                state is ArticlesFail
                    ? Center(
                        child: Text(
                          'Kayıt Bulunamadı!',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      )
                    : Visibility(
                        visible:
                            context.watch<CubitController>().articlesLoading,
                        child: const SkeletonView(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverList sliverList(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom:
                  (context.watch<CubitController>().articles.length - 1 == index
                      ? 15.0
                      : 5),
              left: conf.mainFrameInset,
              right: conf.mainFrameInset,
            ),
            child: Column(
              children: [
                ArticleView(
                  index,
                  library: false,
                  article: context
                      .watch<CubitController>()
                      .articles
                      .elementAt(index),
                  elevation: conf.elevation,
                ),
                (context.watch<CubitController>().articlesLoadingScroll &&
                        index ==
                            context.watch<CubitController>().articles.length -
                                1)
                    ? const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: conf.indicator,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
        },
        childCount: context.watch<CubitController>().articles.length,
      ),
    );
  }

  SliverAppBar sliverAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: conf.backgroundColor,
      pinned: true,
      expandedHeight: conf.appBarHeight,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          top: conf.mainFrameInset,
          left: conf.mainFrameInset,
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            conf.readListText,
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  searchBar() {
    return TextFormField(
      //  controller: searchController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        prefixIcon: conf.searchIcon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: "Ara",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: (value) {},
    );
  }
}
