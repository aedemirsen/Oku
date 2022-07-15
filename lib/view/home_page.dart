import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/TEST.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:yazilar/view/filter_screen.dart';

import 'custom_widgets/elements_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          sliverAppBar(context),
        ],
        body: mainPage(),
      ),

      appBar: appBar(context),
      backgroundColor: Colors.grey.shade200,
      // body: mainPage(),
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

  SliverAppBar sliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 120,
      title: Column(
        children: [
          searchAndFilter(context),
          const Divider(),
          sort(context),
        ],
      ),
    );
  }

  Padding mainPage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: conf.mainFrameInset,
        right: conf.mainFrameInset,
      ),
      child: ElementsView(
        records: TEST.records(),
      ),
    );
  }

  Row searchAndFilter(BuildContext context) {
    return Row(
      children: [
        //search bar
        searchBar(),
        //filter
        filterIcon(context),
      ],
    );
  }

  Flexible filterIcon(BuildContext context) {
    return Flexible(
      child: Center(
        child: GestureDetector(
          onTap: () {
            PageRouter.changePageWithAnimation(
                context,
                const FilterScreen(title: conf.filterScreenTitle),
                PageRouter.downToUp);
          },
          child: conf.filterIcon,
        ),
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
          onChanged: (value) {},
        ),
      ),
    );
  }

  Padding sort(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: conf.sortIcon,
            ),
            Text(
              conf.sortText,
              style: Theme.of(context).textTheme.headline2,
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
