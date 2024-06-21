import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/utils/address.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveInfoCard extends HookConsumerWidget {
  const ReceiveInfoCard({
    required this.coinData,
    required this.networkType,
    required this.walletAddress,
    super.key,
  });

  final CoinData coinData;
  final NetworkType networkType;
  final String walletAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCopied = useState<bool>(false);

    return Row(
      children: <Widget>[
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.appColors.tertararyBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0.s),
                coinData.iconUrl.icon(size: 46.0.s),
                SizedBox(height: UiSize.smallMedium),
                Text(
                  coinData.name,
                  style: context.theme.appTextThemes.body.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
                Text('(${networkType.getDisplayName(context)})'),
                SizedBox(height: UiSize.small),
                QrImageView(
                  data: walletAddress,
                  size: 150,
                ),
                SizedBox(height: UiSize.large),
                Text(
                  shortenAddress(walletAddress),
                  style: context.theme.appTextThemes.body.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
                SizedBox(height: 22.0.s),
                Button(
                  minimumSize: Size(148.0.s, 48.0.s),
                  leadingIcon: isCopied.value
                      ? Assets.images.icons.iconBlockCheckGreen.icon()
                      : Assets.images.icons.iconBlockCopyBlue.icon(),
                  borderColor: isCopied.value
                      ? context.theme.appColors.success
                      : context.theme.appColors.strokeElements,
                  onPressed: () {
                    isCopied.value = true;
                    Future<void>.delayed(const Duration(seconds: 3)).then((_) {
                      isCopied.value = false;
                    });
                  },
                  label: Text(
                    isCopied.value
                        ? context.i18n.wallet_copied
                        : context.i18n.wallet_copy,
                    style: context.theme.appTextThemes.body.copyWith(
                      color: context.theme.appColors.primaryText,
                    ),
                  ),
                  type: ButtonType.secondary,
                ),
                SizedBox(height: UiSize.large),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
