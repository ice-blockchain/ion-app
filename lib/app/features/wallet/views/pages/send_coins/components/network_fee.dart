import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class NetworkFee extends StatelessWidget {
  const NetworkFee({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
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
              child: Assets.images.icons.iconBlockInformation.image(
                width: 16.0.s,
                height: 16.0.s,
              ),
            ),
          ),
        ),
        const Spacer(),
        Text(
          '1.00 USDT',
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
      ],
    );
  }
}
