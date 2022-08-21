import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';
import 'package:yazilar/utility/page_router.dart';
import 'package:yazilar/view/share_opinion.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    context
        .read<CubitController>()
        .getUserNotificationPref(conf.AppConfig.deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            notifications(context),
            shareApp(context),
            shareOpinion(context),
            const Spacer(),
            Center(
              child: Text('Versiyon : ${conf.AppConfig.version}'),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  TextButton shareOpinion(BuildContext context) {
    return TextButton(
      onPressed: () {
        PageRouter.changePageWithAnimation(
            context, ShareOpinion(), PageRouter.downToUp);
      },
      child: SizedBox(
        height: 80,
        width: conf.AppConfig.screenWidth,
        child: Row(
          children: [
            SizedBox(
              width: conf.AppConfig.screenWidth - 100,
              child: Text(
                'Uygulamayı Geliştirmek İçin Fikirlerini Paylaş',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.navigate_next,
                size: 40,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  shareApp(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: SizedBox(
        height: 80,
        width: conf.AppConfig.screenWidth,
        child: Row(
          children: [
            SizedBox(
              width: conf.AppConfig.screenWidth - 100,
              child: Text(
                'İlmi ve Bilgiyi Yaymak İçin Uygulamayı Paylaş',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.share,
                size: 40,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  notifications(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),
      child: SizedBox(
        height: 80,
        width: conf.AppConfig.screenWidth,
        child: Row(
          children: [
            Text(
              'Bildirimlere İzin Ver',
              style: Theme.of(context).textTheme.headline5,
            ),
            const Spacer(),
            context.watch<CubitController>().notificationSettingsLoading
                ? conf.indicator
                : const SizedBox.shrink(),
            buildSwitch(context),
          ],
        ),
      ),
    );
  }

  SizedBox buildSwitch(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 80,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          activeColor: Colors.black,
          value: context.watch<CubitController>().notificationsOn,
          onChanged: (bool val) {
            context.read<CubitController>().changeNotificationOption(val);
          },
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: conf.backgroundColor,
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
