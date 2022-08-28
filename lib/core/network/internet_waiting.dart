import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yazilar/core/cubit/cubit_controller.dart';

class InternetWaiting extends StatefulWidget {
  const InternetWaiting({super.key});

  @override
  State<InternetWaiting> createState() => _InternetWaitingState();
}

class _InternetWaitingState extends State<InternetWaiting> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      crossFadeState: !context.watch<CubitController>().isConnected
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: SizedBox(
        height: 80,
        child: Scaffold(
          backgroundColor: Colors.amber,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'İnternet Bağlantısı Bekleniyor...',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      secondChild: const SizedBox.shrink(),
    );
  }
}
