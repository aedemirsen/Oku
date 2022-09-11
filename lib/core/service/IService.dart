import 'package:dio/dio.dart';
import 'package:Oku/core/model/article.dart';
import 'package:Oku/core/model/opinion.dart';
import 'package:Oku/core/model/user.dart';

abstract class IService {
  final Dio dio;

  final String articlesEndpoint = '/articles';
  final String usersEndpoint = '/users';
  final String opinionsEndpoint = '/opinions';

  IService(this.dio);

  Future<List<Article>> getArticles(Map<String, dynamic> params);

  Future<List<String>> getTitles(Map<String, dynamic> params);

  Future<Article?> getArticle(int id);

  Future<List> getAllCategories();

  Future<List> getAllGroups();

  Future<List> getAllAuthors();

  Future<bool> deleteArticle(String id);

  Future<String> postArticle(Article article);

  Future<bool> postUser(User user);

  Future<User?> getUser(String id);

  Future<bool> updateUser(User user);

  Future<bool> postOpinion(Opinion opinion);
}
