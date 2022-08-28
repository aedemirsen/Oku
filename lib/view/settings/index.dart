import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:yazilar/view/custom_widgets/opened_view.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
    //get all titles
    context.read<CubitController>().getTitles();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: conf.backgroundColor,
          appBar: appBar(context),
          body: context.watch<CubitController>().titlesLoading
              ? const Center(
                  child: conf.indicator,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40),
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: conf.Session.controllerTitle,
                        itemCount:
                            context.watch<CubitController>().allTitles.length,
                        itemBuilder: ((context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10,
                                ),
                                child: SizedBox(
                                  width: conf.AppConfig.screenWidth,
                                  child: TextButton(
                                    onPressed: () {
                                      int id = int.parse(context
                                          .read<CubitController>()
                                          .allTitles
                                          .elementAt(index)
                                          .split('*')[1]);
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
                                                  (element) =>
                                                      element.id == id),
                                            ),
                                            PageRouter.downToUp);
                                      });
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        context
                                                    .watch<CubitController>()
                                                    .allTitles
                                                    .elementAt(index) ==
                                                ''
                                            ? '[Başlık Yok]'
                                            : context
                                                .watch<CubitController>()
                                                .allTitles
                                                .elementAt(index)
                                                .split('*')
                                                .first,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              (context
                                          .watch<CubitController>()
                                          .titlesLoadingScroll &&
                                      index ==
                                          context
                                                  .watch<CubitController>()
                                                  .allTitles
                                                  .length -
                                              1)
                                  ? const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: conf.indicator,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          );
                        }),
                      ),
                      if (!context.read<CubitController>().isConnected &&
                          context.read<CubitController>().allTitles.isEmpty)
                        const Center(
                          child: conf.disconnected,
                        ),
                    ],
                  ),
                ),
        ),
        context.watch<CubitController>().readArticleLoading
            ? Container(
                color: Colors.transparent.withOpacity(0.4),
                child: const Center(
                  child: conf.indicator,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      foregroundColor: Colors.black,
      backgroundColor: conf.backgroundColor,
      title: Text(
        conf.indexTitle,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
