import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';

import 'custom_widgets/elements_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CubitController, AppState>(
        builder: (context, state) {
          if (state is RecordsFail) {
            return Center(
              child: Text(
                'Kayıt Bulunamadı!',
                style: Theme.of(context).textTheme.headline3,
              ),
            );
          } else {
            return Stack(
              children: [
                Visibility(
                  visible: !context.watch<CubitController>().recordsLoading,
                  child: NestedScrollView(
                    floatHeaderSlivers: false,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      sliverAppBar(context),
                    ],
                    body: mainPage(context),
                  ),
                ),
                Visibility(
                  visible: context.watch<CubitController>().recordsLoading,
                  child: const Center(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            );
          }
        },
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

  Padding mainPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: conf.mainFrameInset,
        right: conf.mainFrameInset,
      ),
      child: ElementsView(
        records: context.watch<CubitController>().records,
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
            context.read<CubitController>().getRecords();
            // PageRouter.changePageWithAnimation(
            //     context,
            //     const FilterScreen(title: conf.filterScreenTitle),
            //     PageRouter.downToUp);
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
