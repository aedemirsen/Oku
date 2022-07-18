import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yazilar/core/model/record.dart';
import 'IService.dart';

class Service extends IService {
  Service(super.dio);

  @override
  Future<List<Record>> getRecords({String params = ''}) async {
    try {
      final response = await dio.get(
        endpoint,
      );
      if (response.statusCode == HttpStatus.ok) {
        return (response.data as List)
            .map((country) => Record.fromJson(country))
            .toList();
      }
    } on Exception {
      return [];
    }
    return [];
  }

  @override
  Future<bool> deleteRecord(String id) async {
    final response = await dio.delete(
      "$endpoint/$id",
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  @override
  Future<String> postRecord(Record record) async {
    final response = await dio.post(endpoint, data: record);
    if (response.statusCode == HttpStatus.ok) {
      return response.data["id"];
    }
    return "";
  }
}
