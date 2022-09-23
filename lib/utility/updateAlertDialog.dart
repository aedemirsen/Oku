import 'package:Oku/config/config.dart';
import 'package:Oku/core/cubit/cubit_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAlert extends StatelessWidget {
  const UpdateAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      body: AppConfig.device == 'ios'
          ? CupertinoAlertDialog(
              title: const Text('Yeni Güncelleme Mevcut'),
              content: const Text(
                  'Yeni bir güncelleme mevcut, lütfen şimdi güncelleyin.'),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: ElevatedButton(
                    child: const Text('Şimdi Güncelle'),
                    onPressed: () async {
                      if (!await launchUrl(
                        AppConfig.appStore,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch ${AppConfig.appStore}';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: ElevatedButton(
                    child: const Text('Daha Sonra'),
                    onPressed: () {
                      context.read<CubitController>().changeNeedUpdate(false);
                    },
                  ),
                ),
              ],
            )
          : AlertDialog(
              title: const Text('Yeni Güncelleme Mevcut'),
              content: const Text(
                  'Yeni bir güncelleme mevcut, lütfen şimdi güncelleyin.'),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: ElevatedButton(
                    child: const Text('Şimdi Güncelle'),
                    onPressed: () async {
                      if (!await launchUrl(
                        AppConfig.playStore,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw 'Could not launch ${AppConfig.playStore}';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: ElevatedButton(
                    child: const Text('Daha Sonra'),
                    onPressed: () {
                      context.read<CubitController>().changeNeedUpdate(false);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
