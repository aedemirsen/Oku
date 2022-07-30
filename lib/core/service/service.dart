import 'dart:io';
import 'package:yazilar/core/model/article.dart';
import 'IService.dart';

class Service extends IService {
  Service(super.dio);

  @override
  Future<List<Article>> getArticles(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
        "$endpoint/params",
        queryParameters: params,
      );
      if (response.statusCode == HttpStatus.ok) {
        return (response.data as List)
            .map((article) => Article.fromJson(article))
            .toList();
      }
    } on Exception {
      return [];
    }
    return [];
  }

  @override
  Future<List> getAllCategories() async {
    try {
      final response = await dio.get(
        "$endpoint/categories",
      );
      if (response.statusCode == HttpStatus.ok) {
        return (response.data as List)
            .map((article) => article.toString())
            .toList();
      }
    } on Exception {
      return [];
    }
    return [];
  }

  @override
  Future<List> getAllGroups() async {
    try {
      final response = await dio.get(
        "$endpoint/groups",
      );
      if (response.statusCode == HttpStatus.ok) {
        return (response.data as List)
            .map((article) => article.toString())
            .toList();
      }
    } on Exception {
      return [];
    }
    return [];
  }

  @override
  Future<bool> deleteArticle(String id) async {
    final response = await dio.delete(
      "$endpoint/$id",
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  @override
  Future<String> postArticle(Article article) async {
    final response = await dio.post(endpoint, data: article);
    if (response.statusCode == HttpStatus.ok) {
      return response.data["id"];
    }
    return "";
  }
}
