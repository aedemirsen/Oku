import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Oku/config/config.dart' as conf;
import 'package:Oku/config/config.dart';
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:Oku/utility/page_router.dart';
import 'package:Oku/view/custom_widgets/article_view.dart';
import 'package:Oku/view/filter/filter_screen.dart';
import 'custom_widgets/skeleton_view.dart';
import 'package:Oku/utility/bottom_sheet.dart' as bs;

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
      top: false,
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
                        key: const PageStorageKey('scrollKey'),
                        controller: conf.Session.controller,
                        slivers: <Widget>[
                          sliverAppBar(context),
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
                                top: conf.appBarHeight + 100,
                              ),
                              child: const SkeletonView(),
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
          upButton(context),
        ],
      ),
    );
  }

  Visibility upButton(BuildContext context) {
    return Visibility(
      visible: context.watch<CubitController>().upVisible,
      child: Padding(
        padding: const EdgeInsets.only(right: 30.0, bottom: 10),
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
              color: Theme.of(context).primaryColor,
            ),
            height: 50,
            width: 50,
            child: const Icon(
              Icons.arrow_upward,
              size: 30,
              color: conf.cardColor,
            ),
          ),
        ),
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
      toolbarHeight: conf.appBarHeight / 3,
      //backgroundColor: conf.,
      pinned: true,
      expandedHeight: conf.appBarHeight + 100,
      collapsedHeight: conf.appBarHeight / 2,
      flexibleSpace: FlexibleSpaceBar(
        background: FittedBox(
          fit: BoxFit.fill,
          child: Image.asset('assets/appbar.jpg'),
        ),
        titlePadding: EdgeInsets.only(
          bottom: 50,
          left: conf.mainFrameInset,
          right: conf.mainFrameInset,
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              conf.readListText,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 40),
        child: Visibility(
          visible: !context.watch<CubitController>().articlesLoading,
          child: Material(
            elevation: 10,
            child: Container(
              color: conf.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    sort(context),
                    Container(
                      color: Colors.black,
                      width: 0.5,
                      height: conf.sortFilterHeight - 10,
                    ),
                    filter(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector sort(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          context.watch<CubitController>().orderBy == 'desc'
              ? conf.sort9_1
              : conf.sort1_9,
          const SizedBox(
            width: 10,
          ),
          Text(
            'Sırala',
            style: Theme.of(context).textTheme.headline2,
          ),
        ],
      ),
      onTap: () {
        bs.showBottomSheet(context);
      },
    );
  }

  GestureDetector filter(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PageRouter.changePageWithAnimation(
            context, const FilterScreen(), PageRouter.upToDown);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Filtrele',
            style: Theme.of(context).textTheme.headline2,
          ),
          const SizedBox(
            width: 10,
          ),
          conf.filterIcon,
        ],
      ),
    );
  }

  // searchBar() {
  //   return SizedBox(
  //     height: 30,
  //     width: conf.searchBarWidth,
  //     child: TextField(
  //       cursorHeight: 25,
  //       cursorColor: Colors.black,
  //       //  controller: searchController,
  //       keyboardType: TextInputType.text,
  //       decoration: InputDecoration(
  //         hintStyle: const TextStyle(fontSize: 25),
  //         contentPadding: EdgeInsets.zero,
  //         prefixIcon: conf.searchIconOpened,
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         hintText: "Ara",
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //       onChanged: (value) {},
  //     ),
  //   );
  // }
}
