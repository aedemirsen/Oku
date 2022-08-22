import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/model/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/cubit/cubit_controller.dart';

class ArticleView extends StatefulWidget {
  const ArticleView(this.index,
      {Key? key, this.elevation, required this.article, required this.library})
      : super(key: key);

  final int index;
  final bool library;
  final double? elevation;
  final Article article;

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
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

  openedView(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
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
                      share(),
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
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10),
                            child: Text(
                              (widget.article.title ?? '-'),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          //yazar
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${widget.article.author}',
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
                                  (widget.article.category ?? '').isNotEmpty
                                      ? Row(
                                          children: widget.article.category!
                                              .split(',')
                                              .map(
                                                (e) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: conf
                                                            .categoryBorderColor,
                                                      ),
                                                      //color: conf.categoryBadgeColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
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
                                    width: 5,
                                  ),
                                  (widget.article.group ?? '').isNotEmpty
                                      ? groupBadge()
                                      : const SizedBox.shrink(),
                                  const Spacer(),
                                  //date
                                  Text(
                                    widget.article.dateMiladi ?? '-',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ],
                              ),
                              //hicri date
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.article.dateHicri ?? '-',
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
                                  '${widget.article.body}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: context
                                        .watch<CubitController>()
                                        .selectedFontSize,
                                  ),
                                  textAlign: TextAlign.justify,
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
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: fontSettings(context),
          ),
        ],
      ),
    );
  }

  Visibility fontSettings(BuildContext context) {
    return Visibility(
      visible: context.watch<CubitController>().fontSettingsVisible,
      child: Container(
        height: conf.AppConfig.screenHeight / 12,
        width: conf.AppConfig.screenWidth / 1.5,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(conf.radius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                thumbColor: Colors.black,
                activeColor: Colors.black,
                inactiveColor: Colors.grey,
                value: context.watch<CubitController>().selectedFontSize,
                label: context
                    .watch<CubitController>()
                    .selectedFontSize
                    .round()
                    .toString(),
                divisions: 10,
                onChanged: (double val) {
                  context.read<CubitController>().changeFontSize(val);
                },
                min: 13,
                max: 40,
              ),
            ),
            //close
            GestureDetector(
              onTap: () {
                context
                    .read<CubitController>()
                    .changeFontSettingsVisibility(false);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  size: conf.backIconSize,
                ),
              ),
            ),
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
          child: Text(widget.article.category ?? '-'),
        ),
      ),
    );
  }

  GestureDetector like(BuildContext context) {
    return GestureDetector(
      child: Icon(
        context
                .watch<CubitController>()
                .favorites
                .containsKey(widget.article.id)
            ? conf.favEnabledIcon
            : conf.favDisabledIcon,
        color: conf.favColor,
        size: conf.favIconSize,
      ),
      onTap: () {
        context.read<CubitController>().favorites.containsKey(widget.article.id)
            ? context
                .read<CubitController>()
                .removeFromFavorites(widget.article.id)
            : context.read<CubitController>().addToFavorites(widget.article);
      },
    );
  }

  GestureDetector font(BuildContext context) {
    return GestureDetector(
      child: conf.fontIcon,
      onTap: () {
        context.read<CubitController>().changeFontSettingsVisibility(true);
      },
    );
  }

  GestureDetector share() {
    return GestureDetector(
      child: const Icon(
        conf.shareIcon,
        color: conf.shareIconColor,
        size: conf.shareIconSize,
      ),
      onTap: () async {
        await Share.share(
          "${widget.article.title?.toUpperCase()}\n\n${widget.article.body}",
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
        context.read<CubitController>().changeFontSettingsVisibility(false);
        Navigator.pop(context);
      },
    );
  }

  Card closedView(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(conf.radius),
      ),
      elevation: widget.elevation ?? 1, //default 1
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
                    (widget.article.category ?? '').isNotEmpty
                        ? Row(
                            children: widget.article.category!
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
                      widget.article.dateMiladi ?? '-',
                      style: Theme.of(context).textTheme.headline2,
                    )
                  ],
                ),
                //hicri date
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.article.dateHicri ?? '-',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ],
            ),
            const Divider(),
            //title
            Text(
              widget.article.title ?? "-",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.headline3,
            ),
            //body
            !context.watch<CubitController>().onlyTitles
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      widget.article.body ?? "-",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      maxLines: widget.index == 0 && !widget.library ? 10 : 3,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
