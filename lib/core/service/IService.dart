import 'package:dio/dio.dart';
import 'package:yazilar/core/model/article.dart';
import 'package:yazilar/core/model/opinion.dart';
import 'package:yazilar/core/model/user.dart';

abstract class IService {
  final Dio dio;

  final String endpoint = '/articles';
  final String usersEndpoint = '/users';
  final String opinionsEndpoint = '/opinions';

  IService(this.dio);

  Future<List<Article>> getArticles(Map<String, dynamic> params);

  Future<List> getAllCategories();

  Future<List> getAllGroups();

  Future<bool> deleteArticle(String id);

  Future<String> postArticle(Article article);

  Future<bool> postUser(User user);

  Future<User?> getUser(String id);

  Future<bool> updateUser(User user);

  Future<bool> postOpinion(Opinion opinion);
}
