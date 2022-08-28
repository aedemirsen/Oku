import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/config/config.dart' as conf;

import '../custom_widgets/custom_button.dart';

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  void initState() {
    //get all groups
    context.read<CubitController>().getGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      appBar: appBar(context),
      body: context.watch<CubitController>().groupsLoading
          ? const Center(
              child: conf.indicator,
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: context.watch<CubitController>().groups.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                context.watch<CubitController>().groups.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: (() {
                                    context
                                        .read<CubitController>()
                                        .addSelectedGroups(context
                                            .read<CubitController>()
                                            .groups
                                            .elementAt(index));
                                  }),
                                  child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                conf.AppConfig.screenWidth -
                                                    100,
                                          ),
                                          child: Text(
                                            context
                                                .watch<CubitController>()
                                                .groups
                                                .elementAt(index),
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      context
                                              .watch<CubitController>()
                                              .selectedGroups
                                              .contains(context
                                                  .watch<CubitController>()
                                                  .groups
                                                  .elementAt(index))
                                          ? conf.checkIcon
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 50,
                            top: 20,
                            left: 20,
                            right: 20,
                          ),
                          child: SizedBox(
                            width: conf.AppConfig.screenWidth,
                            height: conf.filterButtonHeight,
                            child: CustomButton(
                              color: conf.backgroundColor,
                              borderColor: Colors.black,
                              child: const Text(
                                conf.cleanFilter,
                                style: TextStyle(color: Colors.black),
                              ),
                              callback: () {
                                context.read<CubitController>().clearGroups();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : !context.read<CubitController>().isConnected &&
                          context.read<CubitController>().groups.isEmpty
                      ? const Center(
                          child: conf.disconnected,
                        )
                      : Center(
                          child: Text(
                            'Seri mevcut değil!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
            ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      foregroundColor: Colors.black,
      backgroundColor: conf.backgroundColor,
      title: Text(
        conf.groupTitle,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
