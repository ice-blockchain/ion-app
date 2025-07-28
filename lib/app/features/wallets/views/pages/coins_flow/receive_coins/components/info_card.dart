// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0.s, horizontal: 18.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.tertiaryBackground,
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
              style: context.theme.appTextThemes.caption3.copyWith(
                color: context.theme.appColors.primaryAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
