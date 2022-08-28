import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:yazilar/view/custom_widgets/custom_button.dart';
import 'package:yazilar/view/custom_widgets/opened_view.dart';

class ReadArticlesPage extends StatelessWidget {
  const ReadArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: context.watch<CubitController>().readArticles.isNotEmpty
          ? Column(
              children: [
                SizedBox(
                  height: conf.filterButtonHeight,
                  child: CustomButton(
                    callback: () {
                      context.read<CubitController>().clearReadArticles();
                    },
                    color: conf.backgroundColor,
                    borderColor: Colors.black,
                    child: const Text(
                      conf.clearReadArticles,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        context.watch<CubitController>().readArticles.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10,
                        ),
                        child: SizedBox(
                          width: conf.AppConfig.screenWidth,
                          child: TextButton(
                            onPressed: () {
                              int id = context
                                  .read<CubitController>()
                                  .readArticles
                                  .keys
                                  .elementAt(index);
                              context
                                  .read<CubitController>()
                                  .getArticle(id)
                                  .then((value) {
                                List<Article> articles = context
                                    .read<CubitController>()
                                    .selectedReadArticle;
                                PageRouter.changePageWithAnimation(
                                    context,
                                    OpenedView(
                                      article: articles.firstWhere(
                                          (element) => element.id == id),
                                    ),
                                    PageRouter.downToUp);
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                context
                                            .watch<CubitController>()
                                            .readArticles
                                            .values
                                            .elementAt(index) ==
                                        ''
                                    ? '[Liste Boş]'
                                    : context
                                        .watch<CubitController>()
                                        .readArticles
                                        .values
                                        .elementAt(index),
                                style: Theme.of(context).textTheme.headline5,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Henüz okunmuş bir yazı mevcut değil!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
    );
  }
}
