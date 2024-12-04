// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/copy/copy_builder.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.dart';
import 'package:ion/app/utils/formatters.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveInfoCard extends HookConsumerWidget {
  const ReceiveInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinData = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.selectedCoin),
    );
    final networkType = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.selectedNetwork),
    );
    final walletAddress = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.address),
    );

    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.appColors.tertararyBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                SizedBox(
                  width: 150.0.s,
                  height: 150.0.s,
                  child: ClipRRect(
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
                ),
                SizedBox(height: 8.0.s),
                Text(
                  shortenAddress(walletAddress),
                  style: context.theme.appTextThemes.body.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
                SizedBox(height: 22.0.s),
                CopyBuilder(
                  defaultIcon: Assets.svg.iconBlockCopyBlue.icon(),
                  defaultText: context.i18n.button_copy,
                  defaultBorderColor: context.theme.appColors.strokeElements,
                  builder: (context, onCopy, content) => Button(
                    minimumSize: Size(148.0.s, 48.0.s),
                    leadingIcon: content.icon,
                    borderColor: content.borderColor,
                    onPressed: () => onCopy(walletAddress),
                    label: Text(
                      content.text,
                      style: context.theme.appTextThemes.body.copyWith(
                        color: context.theme.appColors.primaryText,
                      ),
                    ),
                    type: ButtonType.secondary,
                  ),
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
