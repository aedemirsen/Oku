import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yazilar/core/model/record.dart';
import 'package:yazilar/config/config.dart' as conf;

class RecordView extends StatelessWidget {
  const RecordView(this.index,
      {Key? key, required this.height, this.elevation, required this.record})
      : super(key: key);

  final int index;
  final double height;
  final double? elevation;
  final Record record;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(conf.cardRadius))),
      openShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(conf.cardRadius))),
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Colors.white,
      openBuilder: (context, action) {
        return openedView(context);
      },
      closedBuilder: (context, action) {
        return closedView(context);
      },
      transitionDuration: const Duration(seconds: 1),
      transitionType: ContainerTransitionType.fadeThrough,
    );
  }

  SafeArea openedView(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(conf.mainFrameInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //back - favorite - share
              Row(
                children: [
                  backIcon(context),
                  const Spacer(),
                  like(),
                  const SizedBox(
                    width: 15,
                  ),
                  share(context,
                      "${record.title?.toUpperCase()}\n\n${record.body}"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              //title, category, group and body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //title
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                        child: Text(
                          (record.title ?? '-').toUpperCase(),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      //category - group
                      Row(
                        children: [
                          (record.category ?? '').isNotEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: conf.categoryBadgeColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(record.category ?? '-'),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            width: 15,
                          ),
                          (record.group ?? '').isNotEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: conf.groupBadgeColor,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text('Seri'),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const Spacer(),
                          Text(
                            record.dateMiladi ?? '-',
                            style: Theme.of(context).textTheme.headline2,
                          )
                        ],
                      ),
                      const Divider(),
                      //body
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SelectableText(
                          record.body ?? '-',
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector like() {
    return GestureDetector(
      child: const Icon(
        conf.favDisabledIcon,
        color: conf.favColor,
        size: conf.favIconSize,
      ),
    );
  }

  GestureDetector share(BuildContext context, String text) {
    return GestureDetector(
      child: const Icon(
        conf.shareIcon,
        color: conf.shareIconColor,
        size: conf.shareIconSize,
      ),
      onTap: () async {
        final box = context.findRenderObject() as RenderBox?;
        await Share.share(
          text,
          subject: 'Yazıyı paylaş',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      },
    );
  }

  GestureDetector backIcon(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        conf.backIcon,
        size: conf.backIconSize,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  SizedBox closedView(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(conf.cardRadius),
        ),
        elevation: elevation ?? 1, //default 1
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //category , group and date
              Row(
                children: [
                  (record.category ?? '').isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            //border: Border.all(),
                            color: conf.categoryBadgeColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              record.category ?? '-',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    width: 15,
                  ),
                  (record.group ?? '').isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: conf.groupBadgeColor,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('Seri'),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const Spacer(),
                  Text(
                    record.dateMiladi ?? '-',
                    style: Theme.of(context).textTheme.headline2,
                  )
                ],
              ),
              const Divider(),
              //title
              Text(
                record.title ?? "-",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline3,
              ),
              //body
              index == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        record.body ?? "-",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        maxLines: 6,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
