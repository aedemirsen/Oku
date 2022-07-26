import 'dart:io';

import 'package:yazilar/core/model/record.dart';
import 'IService.dart';
import 'package:yazilar/config/config.dart' as conf;

class Service extends IService {
  Service(super.dio);

  @override
  Future<List<Record>> getAllRecords() async {
    try {
      final response = await dio.get(
        endpoint,
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
  Future<List<Record>> getRecordsQueried(
      String param, dynamic p1, dynamic p2, dynamic p3) async {
    try {
      String path = "$endpoint$param";
      Map<String, dynamic> queryParams = {};
      switch (param) {
        case conf.orderParam:
          if (p2 != null && p3 != null) {
            queryParams = {
              'orderby': p1.toString(),
              'start': p2 as int,
              'limit': p3 as int
            };
          } else if (p2 != null && p3 == null) {
            queryParams = {
              'orderby': p1.toString(),
              'start': p2 as int,
            };
          } else if (p2 == null && p3 != null) {
            queryParams = {
              'orderby': p1.toString(),
              'limit': p3 as int,
            };
          } else {
            queryParams = {
              'orderby': p1.toString(),
            };
          }
          break;
        case conf.filterParam:
          queryParams = {'category': p1.toString(), 'group': p2.toString()};
          break;
      }
      final response = await dio.get(
        path,
        queryParameters: queryParams,
      );
      if (response.statusCode == HttpStatus.ok) {
        return (response.data as List)
            .map((record) => Record.fromJson(record))
            .toList();
      }
    } on Exception catch (e) {
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
