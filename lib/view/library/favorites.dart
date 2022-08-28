import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/view/custom_widgets/article_view.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        conf.mainFrameInset,
      ),
      child: context.watch<CubitController>().favorites.isEmpty
          ? Center(
              child: Text(
                'Henüz beğenilen bir yazı mevcut değil!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            )
          : ListView.builder(
              itemCount: context.watch<CubitController>().favorites.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: (context.watch<CubitController>().favorites.length -
                                1 ==
                            index
                        ? 15.0
                        : 0),
                  ),
                  child: ArticleView(
                    index,
                    library: true,
                    article: context.watch<CubitController>().favorites[context
                        .watch<CubitController>()
                        .favorites
                        .keys
                        .elementAt(index)]!,
                    elevation: conf.elevation,
                  ),
                );
              }),
            ),
    );
  }
}
