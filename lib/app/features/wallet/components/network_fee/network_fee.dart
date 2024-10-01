// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class NetworkFee extends StatelessWidget {
  const NetworkFee({super.key});

  static const String networkFee = '1.00 USDT';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.i18n.wallet_network_fee,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 6.0.s),
          child: IconTheme(
            data: IconThemeData(
              size: 16.0.s,
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                context.theme.appColors.tertararyText,
                BlendMode.srcIn,
              ),
              child: Assets.svg.iconBlockInformation.icon(size: 16.0.s),
            ),
          ),
        ),
        const Spacer(),
        Text(
          networkFee,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
      ],
    );
  }
}
