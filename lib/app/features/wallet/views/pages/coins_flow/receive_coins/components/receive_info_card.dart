import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_selectors.dart';
import 'package:ice/app/utils/address.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveInfoCard extends HookConsumerWidget {
  const ReceiveInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinData = receiveCoinSelector(ref);
    final networkType = receiveNetworkSelector(ref);
    final walletAddress = receiveAddressSelector(ref);

    final isCopied = useState<bool>(false);

    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.appColors.tertararyBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SizedBox(height: 20.0.s),
                coinData.iconUrl.icon(size: 46.0.s),
                SizedBox(height: 10.0.s),
                Text(
                  coinData.name,
                  style: context.theme.appTextThemes.body.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
                Text('(${networkType.getDisplayName(context)})'),
                SizedBox(height: 8.0.s),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0.s),
                  child: QrImageView(
                    backgroundColor: context.theme.appColors.secondaryBackground,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle,
                      color: context.theme.appColors.primaryText,
                    ),
                    embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40.0.s, 40.0.s)),
                    embeddedImage: AssetImage(Assets.images.qrCode.centerQr.path),
                    data: walletAddress,
                    size: 150.0.s,
                  ),
                ),
                SizedBox(height: 8.0.s),
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
                    isCopied.value ? context.i18n.wallet_copied : context.i18n.wallet_copy,
                    style: context.theme.appTextThemes.body.copyWith(
                      color: context.theme.appColors.primaryText,
                    ),
                  ),
                  type: ButtonType.secondary,
                ),
                SizedBox(height: 16.0.s),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
