import 'package:hive_flutter/hive_flutter.dart';
import 'package:yazilar/core/model/article.dart';

class Boxes {
  static Box<Article> getArticles() => Hive.box<Article>('articles');
}
