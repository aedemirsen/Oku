import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/view/custom_widgets/article_view.dart';

class ElementsView extends StatefulWidget {
  const ElementsView({Key? key, required this.articles}) : super(key: key);

  final List<Article> articles;

  @override
  State<ElementsView> createState() => _ElementsViewState();
}

class _ElementsViewState extends State<ElementsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: conf.Session.controller,
            itemCount: widget.articles.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: (widget.articles.length - 1 == index ? 15.0 : 0),
                ),
                child: ArticleView(
                  index,
                  library: false,
                  article: widget.articles.elementAt(index),
                  elevation: conf.elevation,
                ),
              );
            }),
          ),
        ),
        context.watch<CubitController>().articlesLoadingScroll
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: conf.indicator,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
