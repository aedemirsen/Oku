import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/model/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/cubit/cubit_controller.dart';

class ArticleView extends StatelessWidget {
  const ArticleView(this.index,
      {Key? key, this.elevation, required this.article, required this.library})
      : super(key: key);

  final int index;
  final bool library;
  final double? elevation;
  final Article article;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(conf.radius))),
      openShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(conf.radius))),
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Colors.white,
      openBuilder: (context, action) {
        return openedView(context);
      },
      closedBuilder: (context, action) {
        return closedView(context);
      },
      transitionDuration: const Duration(seconds: 1),
      transitionType: ContainerTransitionType.fadeThrough,
    );
  }

  SafeArea openedView(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(conf.mainFrameInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //back - font - favorite - share
              Row(
                children: [
                  backIcon(context),
                  const Spacer(),
                  font(context),
                  const SizedBox(
                    width: 15,
                  ),
                  like(context),
                  const SizedBox(
                    width: 15,
                  ),
                  share(context,
                      "${article.title?.toUpperCase()}\n\n${article.body}"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              //title, category, group and body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //title
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Opacity(
                            opacity: context
                                    .watch<CubitController>()
                                    .fontSettingsVisible
                                ? 0.2
                                : 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 10),
                              child: Text(
                                (article.title ?? '-'),
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ),
                          fontSettings(context),
                        ],
                      ),
                      //yazar
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${article.author}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //category - group - date
                      Column(
                        children: [
                          Row(
                            children: [
                              (article.category ?? '').isNotEmpty
                                  ? Row(
                                      children: article.category!
                                          .split(',')
                                          .map(
                                            (e) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: conf
                                                        .categoryBorderColor,
                                                  ),
                                                  //color: conf.categoryBadgeColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
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
                              const SizedBox(
                                width: 15,
                              ),
                              (article.group ?? '').isNotEmpty
                                  ? groupBadge()
                                  : const SizedBox.shrink(),
                              const Spacer(),
                              //date
                              Text(
                                article.dateMiladi ?? '-',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          ),
                          //hicri date
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              article.dateHicri ?? '-',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      //body
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            SelectableText(
                              '${article.body}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: context
                                    .watch<CubitController>()
                                    .selectedFontSize,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Visibility fontSettings(BuildContext context) {
    return Visibility(
      visible: context.watch<CubitController>().fontSettingsVisible,
      child: Container(
        height: conf.AppConfig.screenHeight / 13,
        width: conf.AppConfig.screenWidth / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 3),
          borderRadius: BorderRadius.circular(conf.radius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: FaIcon(
                conf.font,
                size: conf.fontLarge,
                color: context.watch<CubitController>().selectedFontSize == 25
                    ? conf.selectedFontColor
                    : conf.defaultFontColor,
              ),
              onTap: () {
                context.read<CubitController>().changeFontSize(25);
              },
            ),
            GestureDetector(
              child: FaIcon(
                conf.font,
                size: conf.fontMedium,
                color: context.watch<CubitController>().selectedFontSize == 20
                    ? conf.selectedFontColor
                    : conf.defaultFontColor,
              ),
              onTap: () => context.read<CubitController>().changeFontSize(20),
            ),
            GestureDetector(
              child: FaIcon(
                conf.font,
                size: conf.fontSmall,
                color: context.watch<CubitController>().selectedFontSize == 16
                    ? conf.selectedFontColor
                    : conf.defaultFontColor,
              ),
              onTap: () => context.read<CubitController>().changeFontSize(16),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector groupBadge() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: conf.groupBorderColor,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text('Seri'),
        ),
      ),
    );
  }

  GestureDetector categoryBadge() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: conf.categoryBorderColor),
          //color: conf.categoryBorderColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(article.category ?? '-'),
        ),
      ),
    );
  }

  GestureDetector like(BuildContext context) {
    return GestureDetector(
      child: Icon(
        context.watch<CubitController>().favorites.containsKey(article.id)
            ? conf.favEnabledIcon
            : conf.favDisabledIcon,
        color: conf.favColor,
        size: conf.favIconSize,
      ),
      onTap: () {
        context.read<CubitController>().favorites.containsKey(article.id)
            ? context.read<CubitController>().removeFromFavorites(article.id)
            : context.read<CubitController>().addToFavorites(article);
      },
    );
  }

  GestureDetector font(BuildContext context) {
    return GestureDetector(
      child: conf.fontIcon,
      onTap: () {
        context.read<CubitController>().changeFontSettingsVisibility();
      },
    );
  }

  GestureDetector share(BuildContext context, String text) {
    return GestureDetector(
      child: const Icon(
        conf.shareIcon,
        color: conf.shareIconColor,
        size: conf.shareIconSize,
      ),
      onTap: () async {
        await Share.share(
          text,
          subject: 'Yazıyı paylaş',
          sharePositionOrigin: Rect.fromLTWH(
            0,
            0,
            conf.AppConfig.screenWidth,
            conf.AppConfig.screenHeight / 2,
          ),
        );
      },
    );
  }

  GestureDetector backIcon(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        conf.backIcon,
        size: conf.backIconSize,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Card closedView(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(conf.radius),
      ),
      elevation: elevation ?? 1, //default 1
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
                                    padding: const EdgeInsets.only(right: 5.0),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    article.dateHicri ?? '-',
                    style: Theme.of(context).textTheme.headline2,
                  ),
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
