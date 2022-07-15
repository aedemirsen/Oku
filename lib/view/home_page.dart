import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/TEST.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:yazilar/view/custom_widgets/filter_screen.dart';

import 'custom_widgets/elements_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: appBar(context),
      body: scaffoldBody(),
      bottomNavigationBar: navigationBar(),
    );
  }

  BlocConsumer<CubitController, AppState> scaffoldBody() {
    return BlocConsumer<CubitController, AppState>(
      listener: (context, state) {
        if (state is FilterScreenVisibility) {
          state.isVisible
              ? PageRouter.changePageWithAnimation(
                  context, const FilterScreen(), PageRouter.downToUp)
              : Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return mainPage();
      },
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            child: const Icon(Icons.settings),
          ),
        ),
      ],
    );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Ana Sayfa",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "Kitaplığım",
        ),
      ],
    );
  }

  Padding mainPage() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        bottom: 8.0,
        left: conf.mainFrameInset,
        right: conf.mainFrameInset,
      ),
      child: BlocBuilder<CubitController, AppState>(
        builder: (context, state) {
          return Column(
            children: [
              //search and filter
              searchAndFilter(context),
              const Divider(),
              sort(),
              Expanded(
                child: ElementsView(
                  records: TEST.records(),
                ),
              ),
            ],
          );
        },
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
        child: BlocBuilder<CubitController, AppState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                context
                    .read<CubitController>()
                    .changeFilterScreenVisibility(true);
              },
              child: const Icon(
                conf.filterIcon,
              ),
            );
          },
        ),
      ),
    );
  }

  Flexible searchBar() {
    return Flexible(
      flex: 8,
      child: TextFormField(
        //  controller: searchController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Icon(
            conf.searchIcon,
          ),
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

  Padding sort() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(conf.orderBy),
            ),
            Text('Sırala'),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
