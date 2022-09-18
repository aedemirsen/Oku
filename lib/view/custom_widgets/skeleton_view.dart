import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:Oku/config/config.dart' as conf;

class SkeletonView extends StatelessWidget {
  const SkeletonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            left: conf.mainFrameInset,
            right: conf.mainFrameInset,
          ),
          child: SizedBox(
            height: 265,
            child: Card(
              color: conf.cardColor,
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
                            height: 14,
                            width: 64,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const Spacer(),
                        SkeletonParagraph(
                          style: SkeletonParagraphStyle(
                            lines: 2,
                            spacing: 5,
                            lineStyle: SkeletonLineStyle(
                              height: 8,
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
                        height: 17,
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
                        height: 17,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(
                          conf.radius,
                        ),
                      ),
                    ),
                    //body
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                          lines: 7,
                          spacing: 5,
                          lineStyle: SkeletonLineStyle(
                            height: 8,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(
                              conf.radius,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
