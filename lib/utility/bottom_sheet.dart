import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';

Future<void> showBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: conf.AppConfig.screenHeight * 0.28,
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                  child: Text(
                    'Sırala',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              const Divider(
                height: 0,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  height: conf.bottomSheetElementHeight,
                  width: conf.AppConfig.screenWidth,
                  child: TextButton(
                    onPressed: (() {
                      context.read<CubitController>().changeOrder();
                      Navigator.pop(context);
                    }),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Son yayınlanan önce',
                        style:
                            context.watch<CubitController>().orderBy == 'desc'
                                ? Theme.of(context).textTheme.headline6
                                : Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  height: conf.bottomSheetElementHeight,
                  width: conf.AppConfig.screenWidth,
                  child: TextButton(
                    onPressed: (() {
                      context.read<CubitController>().changeOrder();
                      Navigator.pop(context);
                    }),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'İlk yayınlanan önce',
                        style: context.watch<CubitController>().orderBy == 'asc'
                            ? Theme.of(context).textTheme.headline6
                            : Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
