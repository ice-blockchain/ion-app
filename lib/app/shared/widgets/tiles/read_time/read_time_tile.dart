import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

const double iconSize = 16.0;

class ReadTimeTile extends StatelessWidget {
  const ReadTimeTile({super.key, required this.minutesToRead});

  final int minutesToRead;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.access_time,
          size: iconSize,
          color: context.theme.appColors.feedText,
        ),
        const SizedBox(width: 3.0),
        // Space between icon and text
        Text(
          '$minutesToRead min read',
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.feedText),
        ),
        // Text displaying minutes
      ],
    );
  }
}
