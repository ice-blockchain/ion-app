// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class NetworkFeeOptionWidget extends StatelessWidget {
  const NetworkFeeOptionWidget({
    required this.feeOption,
    super.key,
  });

  final NetworkFeeOption feeOption;

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
          '${formatDouble(feeOption.amount)} ${feeOption.symbol}',
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
      ],
    );
  }
}
