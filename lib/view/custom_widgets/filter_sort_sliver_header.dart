import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:yazilar/view/filter/filter_screen.dart';
import 'package:yazilar/utility/bottom_sheet.dart' as bs;

class FilterSortSliverHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return filterAndSort(context);
  }

  filterAndSort(BuildContext context) {
    return AppBar(
      backgroundColor: conf.backgroundColor,
      title: Padding(
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
        bs.showBottomSheet(context);
      },
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

  @override
  double get maxExtent => conf.sortFilterHeight;

  @override
  double get minExtent => conf.sortFilterHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
