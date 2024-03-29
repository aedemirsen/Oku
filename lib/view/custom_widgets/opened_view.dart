import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:Oku/config/config.dart' as conf;
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:Oku/core/model/article.dart';

class OpenedView extends StatelessWidget {
  const OpenedView({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.cardColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              color: conf.cardColor,
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
                                (article.title ?? '-'),
                                style: Theme.of(context).textTheme.headline1,
                              ),
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
                                        ? categoryBadge(context)
                                        : const SizedBox.shrink(),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    // (article.group ?? '').isNotEmpty
                                    //     ? groupBadge(context)
                                    //     : const SizedBox.shrink(),
                                    const Spacer(),
                                    //date
                                    Text(
                                      article.dateMiladi ?? '-',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ],
                                ),
                                //hicri date
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    article.dateHicri ?? '-',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                            ),
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
                                ],
                              ),
                            ),
                            !context
                                    .watch<CubitController>()
                                    .readArticles
                                    .values
                                    .contains(article.title)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 30,
                                      right: 20,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        context
                                            .read<CubitController>()
                                            .addToReadArticles(article.id ?? -1,
                                                article.title ?? '');
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        conf.signAsRead,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: conf.AppConfig.primaryColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 30,
                                      right: 20,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        context
                                            .read<CubitController>()
                                            .removeFromReadArticles(
                                                article.id!);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        conf.removeFromRead,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: conf.AppConfig.primaryColor,
                                        ),
                                      ),
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
      ),
    );
  }

  Container categoryBadge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: conf.categoryBorderColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          article.category!,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }

  GestureDetector groupBadge(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: conf.groupBorderColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Seriye Git',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
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
          "${article.title?.toUpperCase()}\n\n${article.body}",
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
}
