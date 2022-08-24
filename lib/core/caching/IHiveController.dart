import 'package:yazilar/core/model/article.dart';

abstract class IHiveController {
  Map<dynamic, Article> getArticles();
  Article? getArticle(int id);
  bool addArticle(Article article);
  bool deleteArticle(int id);
  bool addFontSize(double fontSize);
  double? getFontSize();
}
