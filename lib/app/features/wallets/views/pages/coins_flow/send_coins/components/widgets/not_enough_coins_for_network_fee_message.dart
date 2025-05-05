// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class NotEnoughMoneyForNetworkFeeMessage extends HookConsumerWidget {
  const NotEnoughMoneyForNetworkFeeMessage({
    required this.network,
    super.key,
  });

  final NetworkData network;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final coinsRepository = ref.watch(coinsRepositoryProvider);
    final nativeCoinFuture = useMemoized(() => coinsRepository.getNativeCoin(network), [network]);
    final nativeCoin = useFuture(nativeCoinFuture).data;
    final isLoading = nativeCoin == null;

    if (isLoading) return const SizedBox();

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
            nativeCoin.abbreviation,
          ),
          style: context.theme.appTextThemes.body2.copyWith(
            color: colors.secondaryText,
          ),
          children: [
            const TextSpan(text: ' '), // Delimiter
            TextSpan(
              text: locale.wallet_not_enough_coins_to_cover_fee_deposit(
                nativeCoin.abbreviation,
              ),
              style: TextStyle(
                color: colors.primaryAccent,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final coinsInWalletView = await ref.read(coinsInWalletProvider.future);

                  // Try to find the native coin of the network inside of the current wallet view
                  final group = coinsInWalletView.firstWhereOrNull(
                    (group) {
                      final groupWithCoin = group.coins.firstWhereOrNull(
                        (coin) => coin.coin.id == nativeCoin.id,
                      );
                      return groupWithCoin != null;
                    },
                  );

                  if (!context.mounted) return;

                  ref.read(
                    receiveCoinsFormControllerProvider.notifier,
                  )
                    ..setCoin(group ?? CoinsGroup.fromCoin(nativeCoin))
                    ..setNetwork(network);
                  unawaited(
                    ShareAddressDepositRoute().push<void>(context),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
