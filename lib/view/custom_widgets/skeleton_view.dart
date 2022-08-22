import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/cubit/cubit_controller.dart';

class SkeletonView extends StatelessWidget {
  const SkeletonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            left: conf.mainFrameInset,
            right: conf.mainFrameInset,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: SizedBox(
              height: !context.watch<CubitController>().onlyTitles
                  ? (index == 0 ? 300 : 200)
                  : 200,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(conf.radius),
                ),
                elevation: conf.elevation,
                //category , group and date
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(
                                height: 16,
                                width: 64,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          const Spacer(),
                          SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 2,
                              spacing: 5,
                              lineStyle: SkeletonLineStyle(
                                height: 10,
                                width: 120,
                                borderRadius: BorderRadius.circular(
                                  conf.radius,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      //title
                      const SizedBox(
                        height: 10,
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 20,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(
                            conf.radius,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          randomLength: true,
                          height: 20,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(
                            conf.radius,
                          ),
                        ),
                      ),
                      //body
                      !context.watch<CubitController>().onlyTitles
                          ? (index == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: SkeletonParagraph(
                                    style: SkeletonParagraphStyle(
                                      lines: 7,
                                      spacing: 5,
                                      lineStyle: SkeletonLineStyle(
                                        height: 10,
                                        width: double.infinity,
                                        borderRadius: BorderRadius.circular(
                                          conf.radius,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink())
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
