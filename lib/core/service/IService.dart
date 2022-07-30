import 'package:dio/dio.dart';
import 'package:yazilar/core/model/article.dart';

abstract class IService {
  final Dio dio;

  final String endpoint = '/articles';

  IService(this.dio);

  Future<List<Article>> getArticles(Map<String, dynamic> params);

  Future<List> getAllCategories();

  Future<List> getAllGroups();

  Future<bool> deleteArticle(String id);

  Future<String> postArticle(Article article);
}
