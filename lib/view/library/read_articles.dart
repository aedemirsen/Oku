import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:Oku/config/config.dart' as conf;
import 'package:Oku/core/model/article.dart';
import 'package:Oku/utility/page_router.dart';
import 'package:Oku/view/custom_widgets/custom_button.dart';
import 'package:Oku/view/custom_widgets/opened_view.dart';

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
                      _showMyDialog(context);
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

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(conf.radius),
          ),
          title: const Text('Uyarı!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Tüm okunanları kaldırmak istediğinize emin misiniz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Vazgeç'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Kaldır'),
              onPressed: () {
                context.read<CubitController>().clearReadArticles();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
