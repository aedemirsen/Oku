import 'dart:io';

import 'package:yazilar/core/model/record.dart';
import 'IService.dart';
import 'package:yazilar/config/config.dart' as conf;

class Service extends IService {
  Service(super.dio);

  @override
  Future<List<Record>> getRecords(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
        "$endpoint/params",
        queryParameters: params,
      );
      if (response.statusCode == HttpStatus.ok) {
        return (response.data as List)
            .map((record) => Record.fromJson(record))
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
            .map((record) => record.toString())
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
            .map((record) => record.toString())
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
