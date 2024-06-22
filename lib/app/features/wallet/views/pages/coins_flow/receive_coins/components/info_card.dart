import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: UiSize.xxSmall, horizontal: 18.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        borderRadius: BorderRadius.circular(UiSize.medium),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.info_outline,
            color: context.theme.appColors.primaryAccent,
          ),
          SizedBox(width: UiSize.xSmall),
          Expanded(
            child: Text(
              context.i18n.wallet_receive_info,
              style: context.theme.appTextThemes.caption.copyWith(
                color: context.theme.appColors.primaryAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
