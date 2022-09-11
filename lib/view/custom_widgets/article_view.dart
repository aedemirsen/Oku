import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:Oku/config/config.dart' as conf;
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:Oku/core/model/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Oku/view/custom_widgets/closed_view.dart';
import 'package:Oku/view/custom_widgets/opened_view.dart';

class ArticleView extends StatefulWidget {
  const ArticleView(this.index,
      {Key? key,
      required this.elevation,
      required this.article,
      required this.library})
      : super(key: key);

  final int index;
  final bool library;
  final double elevation;
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
        return OpenedView(article: widget.article);
      },
      closedBuilder: (context, action) {
        if (context.watch<CubitController>().showReadArticles) {
          return ClosedView(
            elevation: widget.elevation,
            article: widget.article,
            index: widget.index,
            library: widget.library,
          );
        } else {
          return !context
                      .watch<CubitController>()
                      .readArticles
                      .values
                      .toList()
                      .contains(widget.article.title) ||
                  widget.library
              ? ClosedView(
                  elevation: widget.elevation,
                  article: widget.article,
                  index: widget.index,
                  library: widget.library,
                )
              : const SizedBox.shrink();
        }
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: ContainerTransitionType.fadeThrough,
    );
  }
}
