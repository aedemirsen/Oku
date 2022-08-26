import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/config/config.dart' as conf;
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
                CustomButton(
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
                          child: BlocListener<CubitController, AppState>(
                            listener: (context, state) {
                              if (state is ArticleGetSuccess) {
                                PageRouter.changePageWithAnimation(
                                  context,
                                  OpenedView(article: state.article),
                                  PageRouter.downToUp,
                                );
                              }
                            },
                            child: TextButton(
                              onPressed: () {
                                context.read<CubitController>().getArticle(
                                    context
                                        .read<CubitController>()
                                        .readArticles
                                        .keys
                                        .elementAt(index));
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Flexible(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    context
                                            .watch<CubitController>()
                                            .readArticleLoading
                                        ? Row(
                                            children: const [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              conf.indicator,
                                            ],
                                          )
                                        : SizedBox.fromSize(),
                                  ],
                                ),
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
                  'Henüz Okunmuş Bir Yazı Mevcut Değil!',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
    );
  }
}
