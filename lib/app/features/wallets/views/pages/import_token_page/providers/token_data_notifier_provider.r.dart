// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_form_notifier_provider.r.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_data_notifier_provider.r.g.dart';

@riverpod
class TokenDataNotifier extends _$TokenDataNotifier {
  @override
  Future<CoinData?> build() async => null;

  Future<void> fetchTokenData() async {
    final network = ref.read(tokenFormNotifierProvider.select((state) => state.network));
    final tokenAddress = ref.read(tokenFormNotifierProvider.select((state) => state.address));

    final isEmptyFetchParams = tokenAddress == null || network == null || tokenAddress.isEmpty;
    final isDataAlreadyLoaded = state.hasValue &&
        state.valueOrNull?.contractAddress == tokenAddress &&
        state.valueOrNull?.network.id == network?.id;

    if (isEmptyFetchParams || isDataAlreadyLoaded || state.isLoading) {
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
