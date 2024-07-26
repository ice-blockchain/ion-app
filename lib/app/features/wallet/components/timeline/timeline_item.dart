import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/components/timeline/timeline.dart';
import 'package:ice/generated/assets.gen.dart';

class TimelineItem extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final TimelineItemData data;

  const TimelineItem({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.data,
  }) : super(key: key);

  static double get separatorWidth => 1.0.s;
  static double get separatorHeight => 9.0.s;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: separatorWidth,
                height: separatorHeight,
                color: context.theme.appColors.tertararyText,
              ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  data.isDone
                      ? Assets.images.icons.iconStepsCheckActive.path
                      : Assets.images.icons.iconStepsCheckInactive.path,
                  width: 16.0.s,
                  height: 16.0.s,
                ),
              ],
            ),
            if (!isLast)
              Container(
                width: separatorWidth,
                height: separatorHeight,
                color: context.theme.appColors.tertararyText,
              ),
          ],
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            data.title,
            style: context.theme.appTextThemes.caption.copyWith(
              color: data.isDone
                  ? context.theme.appColors.primaryText
                  : context.theme.appColors.tertararyText,
            ),
          ),
        ),
      ],
    );
  }
}
