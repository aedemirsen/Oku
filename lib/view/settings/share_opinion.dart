import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/cubit/cubit_controller.dart';
import 'package:yazilar/core/model/opinion.dart';
import 'package:yazilar/view/custom_widgets/custom_button.dart';

class ShareOpinion extends StatelessWidget {
  ShareOpinion({Key? key}) : super(key: key);

  final TextEditingController bodyController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: conf.backgroundColor,
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Başlık',
              style: Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20.0),
              child: TextField(
                style: Theme.of(context).textTheme.headline4,
                cursorColor: Colors.black,
                controller: titleController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 3,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 3,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Text(
              'Fikir ve Görüşler',
              style: Theme.of(context).textTheme.headline5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20.0),
                child: TextField(
                  style: Theme.of(context).textTheme.headline4,
                  cursorColor: Colors.black,
                  controller: bodyController,
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: conf.filterButtonHeight,
              width: conf.filterScreenWidth,
              child: CustomButton(
                borderColor: Colors.black,
                color: conf.backgroundColor,
                callback: () {
                  if (titleController.text.isNotEmpty &&
                      bodyController.text.isNotEmpty &&
                      context.read<CubitController>().isConnected) {
                    context.read<CubitController>().addOpinion(
                          Opinion(
                            title: titleController.text,
                            body: bodyController.text,
                          ),
                        );
                    _showMyDialog(context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: context.watch<CubitController>().opinionLoading,
                      child: const SizedBox(
                        width: 15 + conf.filterButtonHeight / 2,
                      ),
                    ),
                    const Text(
                      'Paylaş',
                      style: TextStyle(color: Colors.black),
                    ),
                    Visibility(
                      visible: context.watch<CubitController>().opinionLoading,
                      child: const SizedBox(
                        width: 15,
                      ),
                    ),
                    Visibility(
                      visible: context.watch<CubitController>().opinionLoading,
                      child: const SizedBox(
                        height: conf.filterButtonHeight / 2,
                        width: conf.filterButtonHeight / 2,
                        child: conf.indicator,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
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
        'Fikirlerini Paylaş',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(conf.radius),
          ),
          title: const Text('Bilgi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Geri bildiriminiz ve değerli görüşleriniz için teşekkür ederiz.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
