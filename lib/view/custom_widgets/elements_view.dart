import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/model/record.dart';
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/view/custom_widgets/record_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ElementsView extends StatefulWidget {
  const ElementsView({Key? key, required this.records}) : super(key: key);

  final List<Record> records;

  @override
  State<ElementsView> createState() => _ElementsViewState();
}

class _ElementsViewState extends State<ElementsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: conf.Session.controller,
            itemCount: widget.records.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: (widget.records.length - 1 == index ? 15.0 : 0),
                ),
                child: RecordView(
                  index,
                  record: widget.records.elementAt(index),
                  height:
                      index != 0 ? conf.recordsHeight : conf.firstRecordHeight,
                  elevation: conf.elevation,
                ),
              );
            }),
          ),
        ),
        context.watch<CubitController>().recordsLoadingScroll
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: conf.indicator,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
