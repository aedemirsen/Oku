import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;

class Settings extends StatelessWidget {
  const Settings({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      appBar: appBar(context),
      body: Container(),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: conf.backgroundColor,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
