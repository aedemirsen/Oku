import 'package:dio/dio.dart';
import 'package:yazilar/core/model/record.dart';

abstract class IService {
  final Dio dio;

  final String endpoint = '/articles';

  IService(this.dio);

  Future<List<Record>> getAllRecords();

  Future<List<Record>> getRecordsQueried(
      String param, dynamic p1, dynamic p2, dynamic p3);

  Future<List> getAllCategories();

  Future<List> getAllGroups();

  Future<bool> deleteRecord(String id);

  Future<String> postRecord(Record record);
}
