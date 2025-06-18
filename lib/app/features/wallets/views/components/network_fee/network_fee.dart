// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/info_type.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/views/pages/info/info_modal.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
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
        GestureDetector(
          onTap: () {
            showSimpleBottomSheet<void>(
              context: context,
              child: const InfoModal(
                infoType: InfoType.networkFee,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 6.0.s),
            child: IconTheme(
              data: IconThemeData(
                size: 16.0.s,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  context.theme.appColors.tertararyText,
                  BlendMode.srcIn,
                ),
                child: const IconAsset(Assets.svgIconBlockInformation, size: 16),
              ),
            ),
          ),
        ),
        const Spacer(),
        RichText(
          text: TextSpan(
            text: formatCrypto(feeOption.amount, feeOption.symbol),
            style: context.theme.appTextThemes.body.copyWith(
              color: context.theme.appColors.primaryText,
            ),
            children: [
              const TextSpan(text: ' '),
              TextSpan(
                text: '(~\$${formatDouble(feeOption.priceUSD, maximumFractionDigits: 5)})',
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.quaternaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
