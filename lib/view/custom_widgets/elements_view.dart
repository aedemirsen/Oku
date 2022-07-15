import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/model/record.dart';
import 'package:yazilar/view/custom_widgets/record_view.dart';

class ElementsView extends StatelessWidget {
  const ElementsView({Key? key, required this.records}) : super(key: key);

  final List<Record> records;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: ((context, index) {
        return RecordView(
          index,
          record: records.elementAt(index),
          height: index != 0 ? conf.recordsHeight : conf.firstRecordHeight,
          elevation: conf.elevation,
        );
      }),
    );
  }
}
