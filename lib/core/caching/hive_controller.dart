import 'package:uuid/uuid.dart';
import 'package:Oku/core/caching/IHiveController.dart';
import 'package:Oku/core/caching/boxes.dart';
import 'package:Oku/core/model/article.dart';

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
      if (!Boxes.getConstants().containsKey('fontSize')) {
        addFontSize(16);
      }
      return Boxes.getConstants().get('fontSize') as double;
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

  @override
  Map<dynamic, String> getReadArticles() {
    try {
      return Boxes.getReadArticlesBox().toMap();
    } on Exception {
      return {};
    }
  }

  @override
  bool addReadArticle(int id, String title) {
    try {
      Boxes.getReadArticlesBox().put(id, title);
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  bool removeFromReadArticle(int id) {
    try {
      Boxes.getReadArticlesBox().delete(id);
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  bool getReadArticlesVisibility() {
    try {
      if (!Boxes.getConstants().containsKey('visibility')) {
        toggleReadArticlesVisibility(true);
      }
      return Boxes.getConstants().get('visibility') as bool;
    } on Exception {
      return true;
    }
  }

  @override
  bool toggleReadArticlesVisibility(bool b) {
    try {
      Boxes.getConstants().put('visibility', b);
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  bool clearReadArticles() {
    try {
      Boxes.getReadArticlesBox().clear();
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  String getDeviceId() {
    try {
      if (!Boxes.getConstants().containsKey('deviceId')) {
        var uuid = const Uuid();
        String uniqueId = '${uuid.v1()}${uuid.v4()}';
        addDeviceId(uniqueId);
      }
      return Boxes.getConstants().get('deviceId') as String;
    } on Exception {
      return '';
    }
  }

  @override
  bool addDeviceId(String id) {
    try {
      Boxes.getConstants().put('deviceId', id);
      return true;
    } on Exception {
      return false;
    }
  }
}
