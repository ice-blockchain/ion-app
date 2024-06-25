import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class DescriptionListItem extends StatelessWidget {
  const DescriptionListItem({
    required this.title,
    required this.icon,
    super.key,
  });

  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 43.0.s),
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 11.0.s),
                child: icon,
              ),
            ],
          ),
          Expanded(
            child: Text(
              title,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
