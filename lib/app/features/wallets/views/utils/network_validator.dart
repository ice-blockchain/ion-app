// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/contact_without_wallet_error_modal.dart';

Future<bool> validateNetwork(
  WidgetRef ref,
  String? pubkey,
  NetworkData network,
) async {
  if (pubkey == null) {
    return true;
  }

  final user = await ref.read(userMetadataProvider(pubkey).future);
  final walletsMap = user?.data.wallets ?? {};

  final hasProperWallet = walletsMap[network.id] != null;
  if (!hasProperWallet && ref.context.mounted) {
    unawaited(
      showContactWithoutWalletError(ref.context, user: user!, network: network),
    );
  }

  return hasProperWallet;
}
