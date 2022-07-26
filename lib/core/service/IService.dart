import 'package:dio/dio.dart';
import 'package:yazilar/core/model/record.dart';

abstract class IService {
  final Dio dio;

  final String endpoint = '/articles';

  IService(this.dio);

  Future<List<Record>> getRecords(Map<String, dynamic> params);

  Future<List> getAllCategories();

  Future<List> getAllGroups();

  Future<bool> deleteRecord(String id);

  Future<String> postRecord(Record record);
}
