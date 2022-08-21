import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/caching/IHiveController.dart';
import 'package:yazilar/caching/boxes.dart';

class HiveController extends IHiveController {
  @override
  bool addFontSize(double fontSize) {
    try {
      Boxes.getConstants().put('fontSize', fontSize);
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  double? getFontSize() {
    try {
      if (Boxes.getConstants().isEmpty) {
        addFontSize(16);
      }
      return Boxes.getConstants().getAt(0);
    } on Exception {
      return null;
    }
  }

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