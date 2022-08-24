import 'dart:io';
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/core/model/opinion.dart';
import 'package:yazilar/core/model/user.dart';
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
            .map((category) => category.toString())
            .toList();
      }
    } on Exception {
      return [];
    }
    return [];
  }

  @override
  Future<List> getAllAuthors() async {
    try {
      final response = await dio.get(
        "$endpoint/authors",
      );
      if (response.statusCode == HttpStatus.ok) {
        return (response.data as List)
            .map((author) => author.toString())
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
            .map((group) => group.toString())
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

  @override
  Future<User?> getUser(String id) async {
    try {
      final response = await dio.get(
        "$usersEndpoint/$id",
      );
      if (response.data != false) {
        return User.fromJson((response.data));
      }
    } on Exception {
      return null;
    }
    return null;
  }

  @override
  Future<bool> postUser(User user) async {
    try {
      final response = await dio.post(usersEndpoint, data: user);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
    } on Exception {
      return false;
    }
    return false;
  }

  @override
  Future<bool> updateUser(User user) async {
    try {
      final response = await dio.put('$usersEndpoint/params', queryParameters: {
        'id': user.id,
        'notificationStatus': user.notificationStatus
      });
      if (response.data == user.notificationStatus) {
        return user.notificationStatus!;
      }
    } on Exception {
      return false;
    }
    return false;
  }

  @override
  Future<bool> postOpinion(Opinion opinion) async {
    try {
      final response = await dio.post(opinionsEndpoint, data: opinion);
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }
    } on Exception {
      return false;
    }
    return false;
  }
}
