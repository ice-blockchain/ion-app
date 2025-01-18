// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/tooltip/copied_tooltip.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_button/navigation_button.dart';
import 'package:ion/app/utils/formatters.dart';
import 'package:ion/generated/assets.gen.dart';

class CoinAddressTile extends HookConsumerWidget {
  const CoinAddressTile({
    required this.coinData,
    super.key,
  });

  final CoinData coinData;

  static double get buttonSize => 36.0.s;

  static double get paddingVertical => 30.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.address),
    );
    final isCopied = useState<bool>(false);
    final tooltipLeftPosition = useState<double>(0);

    // TODO: (1) nullability is not implemented. Need to make a request to receive the wallet address
    if (address == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.0.s,
        vertical: paddingVertical,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  coinData.iconUrl.coinIcon(size: 16.0.s),
                  SizedBox(
                    width: 6.0.s,
                  ),
                  Text(
                    context.i18n.wallet_coin_address(
                      coinData.name,
                    ),
                    style: context.theme.appTextThemes.body.copyWith(
                      color: context.theme.appColors.primaryText,
                    ),
                  ),
                  SizedBox(
                    width: 6.0.s,
                  ),
                  Assets.svg.iconBlockInformation.icon(size: 20.0.s),
                ],
              ),
              SizedBox(
                height: 7.0.s,
              ),
              Text(
                shortenAddress(address),
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              NavigationButton(
                icon: Assets.svg.iconBlockCopyBlue.icon(
                  color: context.theme.appColors.primaryText,
                ),
                size: buttonSize,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: address));

                  isCopied.value = true;

                  await Future<void>.delayed(const Duration(seconds: 3)).then((_) {
                    isCopied.value = false;
                  });
                },
              ),
              Positioned(
                top: -paddingVertical,
                left: tooltipLeftPosition.value,
                child: Opacity(
                  opacity: isCopied.value ? 1 : 0,
                  child: CopiedTooltip(
                    onLayout: (Size size) {
                      tooltipLeftPosition.value = (buttonSize - size.width) / 2;
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 16.0.s,
          ),
          NavigationButton(
            size: buttonSize,
            icon: Assets.svg.iconButtonQrcode.icon(
              color: context.theme.appColors.primaryText,
            ),
            onPressed: () {
              ShareAddressCoinDetailsRoute().push<void>(context);
            },
          ),
        ],
      ),
    );
  }
}
