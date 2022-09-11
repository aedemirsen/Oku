import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Oku/config/config.dart' as conf;

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.child,
      required this.callback,
      required this.color,
      required this.borderColor})
      : super(key: key);

  final Widget child;
  final Function()? callback;
  final Color color;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(conf.radius)),
      child: conf.AppConfig.device == 'ios'
          ? CupertinoButton(
              borderRadius: BorderRadius.circular(conf.radius),
              color: color,
              onPressed: callback,
              child: child,
            )
          : ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(conf.radius),
                  ),
                ),
              ),
              onPressed: callback,
              child: child,
            ),
    );
  }
}
