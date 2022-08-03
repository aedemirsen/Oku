import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:yazilar/view/custom_widgets/article_view.dart';
import 'package:yazilar/view/filter_screen.dart';

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
                    filterAndSort(context),
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

  SliverToBoxAdapter filterAndSort(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: conf.mainFrameInset,
          right: conf.mainFrameInset,
        ),
        child: SizedBox(
          height: conf.sortFilterHeight,
          child: Row(
            children: [
              Expanded(child: sort(context)),
              Container(
                color: Colors.black,
                width: 0.5,
              ),
              Expanded(child: filter(context)),
            ],
          ),
        ),
      ),
    );
  }

  SliverList sliverList(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
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
      backgroundColor: conf.backgroundColor,
      pinned: true,
      expandedHeight: conf.appBarHeight,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: conf.mainFrameInset,
          right: conf.mainFrameInset,
        ),
        title: Row(
          children: [
            Text(
              conf.readListText,
              style: Theme.of(context).textTheme.headline3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            IconButton(
              splashRadius: 20,
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: conf.searchIcon,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox customAppBar(BuildContext context) {
    return SizedBox(
      height: conf.appBarHeight,
      child: Padding(
        padding: EdgeInsets.only(
          left: conf.mainFrameInset,
          right: conf.mainFrameInset,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              conf.readListText,
              style: Theme.of(context).textTheme.headline1,
            ),
            const Spacer(),
            SizedBox.square(
              dimension: Theme.of(context).textTheme.headline1!.fontSize,
              child: FittedBox(
                fit: BoxFit.cover,
                child: GestureDetector(
                  onTap: () {},
                  child: conf.searchIcon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row searchAndFilter(BuildContext context) {
    return Row(
      children: [
        //search bar
        searchBar(),
        //filter
        filter(context),
      ],
    );
  }

  GestureDetector filter(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, FilterScreen.route);
        PageRouter.changePageWithAnimation(
            context, const FilterScreen(), PageRouter.downToUp);
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

  Flexible searchBar() {
    return Flexible(
      flex: 8,
      child: SizedBox(
        height: 50,
        child: TextFormField(
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
          onChanged: (value) {
            // value.isEmpty
            //     ? context
            //         .read<CubitController>()
            //         .updateObjectsTable(TEST.objects())
            //     : context.read<CubitController>().updateObjectsTable(TEST
            //         .objects()
            //         .where((element) =>
            //             element.name!.startsWith(value) ||
            //             element.accountnumber.toString().startsWith(value))
            //         .toList());
          },
        ),
      ),
    );
  }

  GestureDetector sort(BuildContext context) {
    return GestureDetector(
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
        showBottomSheet(context);
      },
    );
  }

  Future<void> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: conf.AppConfig.screenHeight * 0.28,
          color: Colors.white,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                    child: Text(
                      'Sırala',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SizedBox(
                    height: conf.bottomSheetElementHeight,
                    width: conf.AppConfig.screenWidth,
                    child: TextButton(
                      onPressed: (() {
                        context.read<CubitController>().changeOrder();
                        Navigator.pop(context);
                      }),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Son yayınlanan önce',
                          style:
                              context.watch<CubitController>().orderBy == 'desc'
                                  ? Theme.of(context).textTheme.headline6
                                  : Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SizedBox(
                    height: conf.bottomSheetElementHeight,
                    width: conf.AppConfig.screenWidth,
                    child: TextButton(
                      onPressed: (() {
                        context.read<CubitController>().changeOrder();
                        Navigator.pop(context);
                      }),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'İlk yayınlanan önce',
                          style:
                              context.watch<CubitController>().orderBy == 'asc'
                                  ? Theme.of(context).textTheme.headline6
                                  : Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
