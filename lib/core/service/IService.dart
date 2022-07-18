import 'package:dio/dio.dart';
import 'package:yazilar/core/model/record.dart';

abstract class IService {
  final Dio dio;

  final String endpoint = '/records';

  IService(this.dio);

  Future<List<Record>> getRecords({String params = ''});

  Future<bool> deleteRecord(String id);

  Future<String> postRecord(Record record);
}
