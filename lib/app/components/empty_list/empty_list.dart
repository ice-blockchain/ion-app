import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
    required this.icon,
    required this.title,
  });
  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          SizedBox(height: 8.0.s),
          Text(
            title,
            style: context.theme.appTextThemes.caption2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
        ],
      ),
    );
  }
}
