import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/config/config.dart' as conf;

class FilterScreen extends StatelessWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      body: filterScreen(context),
    );
  }

  Center filterScreen(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
          color: Colors.white,
        ),
        width: conf.filterScreenWidth,
        height: conf.filterScreenHeight,
        child: Column(
          children: [
            //header
            filterHeader(context),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            const Text('Kategori'),
            filterByCategory(),
            const Spacer(),
            //button
            filterButton(),
          ],
        ),
      ),
    );
  }

  SizedBox filterButton() {
    return SizedBox(
      height: conf.filterButtonHeight,
      width: conf.filterScreenWidth,
      child: CupertinoButton(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(conf.filteScreenRadius),
          bottomLeft: Radius.circular(conf.filteScreenRadius),
        ),
        color: Colors.blue,
        child: const Text("Filtrele"),
        onPressed: () {},
      ),
    );
  }

  SizedBox filterHeader(BuildContext context) {
    return SizedBox(
      height: conf.filtersHeaderHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          //back icon
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 3, 0, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  context
                      .read<CubitController>()
                      .changeFilterScreenVisibility(false);
                },
                icon: const Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.black,
                  size: 40,
                ),
                splashRadius: 23,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          //header
          const Text(
            "Filtrele",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  Padding filterByCategory() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: conf.filterScreenWidth * 0.8,
        child: DropdownButton<String>(
            value: 'asd',
            icon: const SizedBox.shrink(),
            elevation: 16,
            onChanged: (String? newValue) {},
            items: [
              DropdownMenuItem(
                value: 'asd',
                child: Text('asd'),
              ),
              DropdownMenuItem(
                value: 'EKMEk',
                child: Text('EKMEk'),
              ),
              DropdownMenuItem(
                value: 'EKMEk',
                child: Text('EKMEk'),
              ),
              DropdownMenuItem(
                value: 'EKMEk',
                child: Text('EKMEk'),
              ),
            ]),
      ),
    );
  }
}
