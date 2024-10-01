// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class ArrivalTimeIndicator extends ConsumerWidget {
  const ArrivalTimeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;
    final formData = ref.watch(sendAssetFormControllerProvider());

    return Row(
      children: [
        Text(
          locale.wallet_arrival_time_type_normal,
          style: textTheme.body2.copyWith(
            color: colors.secondaryText,
          ),
        ),
        SizedBox(width: 6.0.s),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0.s,
            vertical: 4.0.s,
          ),
          decoration: BoxDecoration(
            color: colors.onSecondaryBackground,
            borderRadius: BorderRadius.circular(15.0.s),
          ),
          child: Row(
            children: [
              Assets.svg.iconBlockTime.icon(
                size: 12.0.s,
              ),
              SizedBox(width: 5.0.s),
              Text(
                '${formData.arrivalTime} ${locale.wallet_arrival_time_minutes}',
                style: textTheme.body2.copyWith(
                  color: colors.primaryAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
