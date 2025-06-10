// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/data/models/coin_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/selected_network_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_address_provider.c.dart';
import 'package:ion/app/services/providers/ion_identity/ion_identity_client_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_data_notifier_provider.c.g.dart';

@riverpod
class TokenDataNotifier extends _$TokenDataNotifier {
  @override
  Future<CoinData?> build() async => null;

  Future<void> fetchTokenData() async {
    final network = ref.read(selectedNetworkProvider);
    final tokenAddress = ref.read(tokenAddressProvider);

    if (tokenAddress == null || network == null || tokenAddress.isEmpty) {
      return;
    }

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityClientProvider.future);
      final coin = await ionIdentity.coins.getCoinData(
        contractAddress: tokenAddress,
        network: network.id,
      );

      return CoinData.fromDTO(coin, network);
    });
  }
}
