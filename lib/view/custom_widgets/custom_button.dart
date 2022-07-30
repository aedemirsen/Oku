import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.title, required this.callback})
      : super(key: key);

  final String title;
  final Function()? callback;
  @override
  Widget build(BuildContext context) {
    return conf.AppConfig.device == 'ios'
        ? CupertinoButton(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: conf.filterButtonColor,
            onPressed: callback,
            child: Text(title),
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(conf.filterButtonColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: callback,
            child: Text(title),
          );
  }
}
