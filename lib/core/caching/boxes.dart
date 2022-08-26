import 'package:hive_flutter/hive_flutter.dart';
import 'package:yazilar/core/model/article.dart';

class Boxes {
  static Box<Article> getArticles() => Hive.box<Article>('articles');
  static Box<Object> getConstants() => Hive.box<Object>('constants');
  static Box<String> getReadArticlesBox() => Hive.box<String>('readArticles');
}
