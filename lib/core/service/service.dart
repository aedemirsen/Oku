import 'package:yazilar/core/model/record.dart';

import 'IService.dart';

class Service extends IService {
  Service(super.dio);

  @override
  Future<List<Record>> getRecords({String params = ''}) {
    // TODO: implement getRecords
    throw UnimplementedError();
  }
}
