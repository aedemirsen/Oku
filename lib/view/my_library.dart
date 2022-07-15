import 'package:flutter/material.dart';

class MyLibrary extends StatelessWidget {
  const MyLibrary({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
