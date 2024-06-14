import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

  static SizedBox sizedBoxWidth10 = SizedBox(width: 10.0.s);
  static EdgeInsetsGeometry infoContainerPadding =
      EdgeInsets.symmetric(vertical: 8.0.s, horizontal: 18.0.s);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: infoContainerPadding,
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.info_outline,
            color: context.theme.appColors.primaryAccent,
          ),
          sizedBoxWidth10,
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
