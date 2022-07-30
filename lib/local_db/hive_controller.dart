import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/local_db/IHiveController.dart';
import 'package:yazilar/local_db/boxes.dart';

class HiveController extends IHiveController {
  @override
  bool addArticle(Article article) {
    try {
      Boxes.getArticles().put(article.id, article);
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  bool deleteArticle(int id) {
    try {
      Boxes.getArticles().delete(id);
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  Article? getArticle(int id) {
    try {
      return Boxes.getArticles().getAt(id);
    } on Exception {
      return null;
    }
  }

  @override
  Map<dynamic, Article> getArticles() {
    try {
      return Boxes.getArticles().toMap();
    } on Exception {
      return {};
    }
  }
}
