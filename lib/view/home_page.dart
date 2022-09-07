import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/cubit/cubit_controller.dart';
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
    //get font size
    context.read<CubitController>().getFontSize();
    //get user notification settings, if the user does not exists add user to db.
    context
        .read<CubitController>()
        .getUserNotificationPref(conf.AppConfig.deviceId);

    //get read articles from local db
    context.read<CubitController>().getAllReadArticles();

    //get show option for read articles
    context.read<CubitController>().getReadArticlesVisibility();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Scaffold(
            backgroundColor: conf.backgroundColor,
            body: BlocBuilder<CubitController, AppState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        context.read<CubitController>().resetAndSearch();
                      },
                      child: CustomScrollView(
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
                    ),
                    if (!context.read<CubitController>().isConnected &&
                        context.read<CubitController>().articles.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Center(
                          child: conf.disconnected,
                        ),
                      ),
                    state is ArticlesFail
                        ? Center(
                            child: Text(
                              'Kayıt bulunamadı.',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )
                        : Visibility(
                            visible: context
                                .watch<CubitController>()
                                .articlesLoading,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: conf.appBarHeight + 45,
                              ),
                              child: const SkeletonView(),
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
          Visibility(
            visible: context.watch<CubitController>().upVisible,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  conf.Session.controller?.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(conf.radius),
                    color: Colors.blue.shade200,
                  ),
                  height: 50,
                  width: 50,
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverList sliverList(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Visibility(
            visible: !context.watch<CubitController>().articlesLoading,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: (context.watch<CubitController>().articles.length - 1 ==
                        index
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
          bottom: conf.mainFrameInset / 2,
          left: conf.mainFrameInset,
          right: conf.mainFrameInset,
        ),
        title: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Text(
                conf.readListText,
                style: Theme.of(context).textTheme.subtitle1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // const Spacer(),
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       _searchBarVisible = true;
              //     });
              //   },
              //   child: conf.searchIcon,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  searchBar() {
    return SizedBox(
      height: 30,
      width: conf.searchBarWidth,
      child: TextField(
        cursorHeight: 25,
        cursorColor: Colors.black,
        //  controller: searchController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 25),
          contentPadding: EdgeInsets.zero,
          prefixIcon: conf.searchIconOpened,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: "Ara",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {},
      ),
    );
  }
}
