// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion_identity_client/ion_identity.dart' as ion;

class NotEnoughMoneyForNetworkFeeMessage extends ConsumerWidget {
  const NotEnoughMoneyForNetworkFeeMessage({
    required this.network,
    required this.coinAsset,
    required this.networkToken,
    super.key,
  });

  final CoinAssetToSendData coinAsset;
  final ion.WalletAsset networkToken;
  final NetworkData network;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      padding: EdgeInsets.symmetric(
        vertical: 12.0.s,
        horizontal: 16.0.s,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        border: Border.fromBorderSide(
          BorderSide(
            color: colors.onTerararyFill,
            width: 1.0.s,
          ),
        ),
        color: colors.tertararyBackground,
      ),
      child: RichText(
        text: TextSpan(
          text: locale.wallet_not_enough_coins_to_cover_fee_desc(
            networkToken.symbol,
          ),
          style: context.theme.appTextThemes.body2.copyWith(
            color: colors.secondaryText,
          ),
          children: [
            const TextSpan(text: ' '), // Delimiter
            TextSpan(
              text: locale.wallet_not_enough_coins_to_cover_fee_deposit(
                networkToken.symbol,
              ),
              style: TextStyle(
                color: colors.primaryAccent,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ref.read(
                    receiveCoinsFormControllerProvider.notifier,
                  )
                    ..setCoin(coinAsset.coinsGroup)
                    ..setNetwork(network);
                  ShareAddressDepositRoute().push<void>(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}
