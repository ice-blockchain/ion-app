import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class TransactionSectionHeader extends StatelessWidget {
  const TransactionSectionHeader({
    required this.date,
    super.key,
  });

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: UiSize.xSmall,
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
