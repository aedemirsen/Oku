import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/core/model/article.dart';

class ClosedView extends StatelessWidget {
  const ClosedView(
      {Key? key,
      required this.article,
      required this.elevation,
      required this.index,
      required this.library})
      : super(key: key);

  final Article article;
  final double elevation;
  final int index;
  final bool library;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(conf.radius),
      ),
      elevation: elevation, //default 1
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //categories, group and date
            Column(
              children: [
                Row(
                  children: [
                    //categories
                    (article.category ?? '').isNotEmpty
                        ? Row(
                            children: article.category!
                                .split(',')
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(
                                      right: 5.0,
                                      bottom: 3,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: conf.categoryBorderColor,
                                        ),
                                        //color: conf.categoryBadgeColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          e,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : const SizedBox.shrink(),
                    const Spacer(),
                    Text(
                      article.dateMiladi ?? '-',
                      style: Theme.of(context).textTheme.headline2,
                    )
                  ],
                ),
                //hicri date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    context
                            .watch<CubitController>()
                            .readArticles
                            .values
                            .contains(article.title)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 1.0),
                            child: Row(
                              children: const [
                                Text(
                                  conf.alreadyRead,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                conf.checkIcon,
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    Text(
                      article.dateHicri ?? '-',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            //title
            Text(
              article.title ?? "-",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.headline3,
            ),
            //body
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                article.body ?? "-",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                maxLines: index == 0 && !library ? 10 : 3,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
