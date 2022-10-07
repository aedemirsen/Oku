import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:Oku/config/config.dart' as conf;
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:Oku/utility/page_router.dart';
import 'package:Oku/view/settings/index.dart';
import 'package:Oku/view/settings/share_opinion.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Expanded(
              child: ListView(
                children: [
                  kIsWeb ? const SizedBox.shrink() : notifications(context),
                  index(context),
                  changeViewOfRead(context),
                  shareApp(context),
                  shareOpinion(context),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(
                      conf.url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw 'Could not launch ${conf.url}';
                    }
                  },
                  child: Text(
                    '@oku.bilgimeclisi.com',
                    style: TextStyle(color: conf.AppConfig.primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text('versiyon: ${conf.AppConfig.version}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextButton changeViewOfRead(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<CubitController>().toggleReadArticlesVisibility();
      },
      child: SizedBox(
        height: 50,
        width: conf.AppConfig.screenWidth,
        child: Row(
          children: [
            SizedBox(
              width: conf.AppConfig.screenWidth - 100,
              child: Text(
                context.read<CubitController>().showReadArticles
                    ? 'Okunan Yazıları Gizle'
                    : 'Okunan Yazıları Göster',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 25.0),
              child: FaIcon(
                FontAwesomeIcons.eye,
                size: 20,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  TextButton shareOpinion(BuildContext context) {
    return TextButton(
      onPressed: () {
        PageRouter.changePageWithAnimation(
            context, ShareOpinion(), PageRouter.upToDown);
      },
      child: SizedBox(
        height: 50,
        width: conf.AppConfig.screenWidth,
        child: Row(
          children: [
            SizedBox(
              width: conf.AppConfig.screenWidth - 100,
              child: Text(
                'Uygulamanın Gelişmesi İçin Fikirlerini Bizimle Paylaş',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: FaIcon(
                FontAwesomeIcons.penToSquare,
                size: 20,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  TextButton index(BuildContext context) {
    return TextButton(
      onPressed: () {
        PageRouter.changePageWithAnimation(
            context, const IndexPage(), PageRouter.upToDown);
      },
      child: SizedBox(
        height: 50,
        width: conf.AppConfig.screenWidth,
        child: Row(
          children: [
            SizedBox(
              width: conf.AppConfig.screenWidth - 100,
              child: Text(
                'Fihrist',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 25.0),
              child: FaIcon(
                FontAwesomeIcons.chevronRight,
                size: 20,
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
      onPressed: () async {
        await Share.share(
          "X",
          subject: 'Uygulamayı paylaş',
          sharePositionOrigin: Rect.fromLTWH(
            0,
            0,
            conf.AppConfig.screenWidth,
            conf.AppConfig.screenHeight / 2,
          ),
        );
      },
      child: SizedBox(
        height: 50,
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
                size: 20,
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
      //backgroundColor: conf.backgroundColor,
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
