import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/components/timeline/timeline.dart';
import 'package:ice/app/features/wallet/components/timeline/timeline_separator.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:intl/intl.dart';

class TimelineItem extends StatelessWidget {
  final bool isLast;
  final TimelineItemData data;
  final bool? isNextDone;

  const TimelineItem({
    Key? key,
    required this.isLast,
    required this.data,
    this.isNextDone = false,
  }) : super(key: key);

  static double get separatorWidth => 1.0.s;
  static double get separatorHeight => 9.0.s;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
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
              TimelineSeparator(
                color: isNextDone != null && isNextDone!
                    ? context.theme.appColors.primaryAccent
                    : context.theme.appColors.tertararyText,
              ),
          ],
        ),
        SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              if (data.date != null)
                Text(
                  DateFormat('dd.MM.yyyy HH:mm:ss').format(data.date!),
                  style: context.theme.appTextThemes.caption3.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
