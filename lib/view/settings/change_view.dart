import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/utility/toast.dart';
import 'package:yazilar/view/custom_widgets/custom_button.dart';

class ChangeView extends StatelessWidget {
  const ChangeView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
        child: Column(
          children: [
            onlyTitles(context),
            extendedView(context),
            const Spacer(),
            changeViewButton(context),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox changeViewButton(BuildContext context) {
    return SizedBox(
      height: conf.filterButtonHeight,
      width: conf.filterScreenWidth,
      child: CustomButton(
        borderColor: Colors.black,
        color: conf.backgroundColor,
        child: const Text(
          'Görünümü Değiştir',
          style: TextStyle(color: Colors.black),
        ),
        callback: () {
          showToastMessage(context.read<CubitController>().onlyTitles
              ? 'Sadece Başlıklar Görünecek'
              : 'Geniş Görünüm');
          context.read<CubitController>().changePage(0);
          Navigator.pop(context);
        },
      ),
    );
  }

  TextButton extendedView(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<CubitController>().changeView(false);
      },
      child: SizedBox(
        height: 40,
        width: conf.AppConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Geniş Görünüm',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              const Spacer(),
              !context.watch<CubitController>().onlyTitles
                  ? conf.checkIcon
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  TextButton onlyTitles(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<CubitController>().changeView(true);
      },
      child: SizedBox(
        height: 40,
        width: conf.AppConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sadece Başlıklar',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              const Spacer(),
              context.watch<CubitController>().onlyTitles
                  ? conf.checkIcon
                  : const SizedBox.shrink(),
            ],
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
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
