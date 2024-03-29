import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.date,
  });

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: 10.0.s,
      ),
      child: Text(
        date,
        style: context.theme.appTextThemes.caption3.copyWith(
          color: context.theme.appColors.tertararyText,
        ),
      ),
    );
  }
}
