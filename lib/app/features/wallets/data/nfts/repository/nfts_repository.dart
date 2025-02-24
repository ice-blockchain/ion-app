// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/nfts/mappers/nft_mapper.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final nftsRepositoryProvider = Provider.autoDispose((ref) {
  return NftsRepository(
    ionIdentityClient: ref.watch(ionIdentityClientProvider).valueOrNull!,
  );
});

class NftsRepository {
  NftsRepository({
    required IONIdentityClient ionIdentityClient,
  }) : _ionIdentityClient = ionIdentityClient;

  final IONIdentityClient _ionIdentityClient;

  Future<List<NftData>> getNfts({
    required String walletViewId,
    required String walletId,
  }) async {
    final nfts = await _ionIdentityClient.wallets.getWalletNfts(walletId);
    if (nfts.nfts.isEmpty) {
      return [];
    }

    return nfts.nfts.map((nft) => nft.toNft(network: nfts.network)).toList();
  }
}
