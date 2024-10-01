// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
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
      padding: EdgeInsets.symmetric(vertical: 8.0.s, horizontal: 18.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.theme.appColors.primaryAccent,
          ),
          SizedBox(width: 10.0.s),
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
