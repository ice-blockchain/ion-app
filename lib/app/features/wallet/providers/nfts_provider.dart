// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/wallet/model/nft_data.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfts_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<NftData>> nftsData(Ref ref) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    return [];
  }
  final currentWalletId = await ref.watch(currentWalletIdProvider.future);

  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  final walletNfts =
      await ionIdentity(username: currentUser).wallets.getWalletNfts(currentWalletId);

  final coins = [
    // ignore: unused_local_variable
    for (final (index, nft) in walletNfts.nfts.indexed)
      // TODO: get actual NFT data
      const NftData(
        collectionName: 'COLLECTION NULL',
        identifier: -100,
        price: -100,
        currency: 'CURRENCY NULL',
        iconUrl: 'ICONURL NULL',
        currencyIconUrl: 'CURRENCYICONURL NULL',
        description: 'DESCRIPTION NULL',
        network: 'NETWORK NULL',
        tokenStandard: 'TOKENSTANDARD NULL',
        contractAddress: 'CONTRACTADDRESS NULL',
        rank: -100,
        asset: 'ASSET NULL',
      ),
  ];

  return coins;
}

@riverpod
Future<NftData> nftById(Ref ref, {required int coinId}) async {
  final coins = await ref.watch(nftsDataProvider.future);

  return coins.firstWhere((NftData nft) => nft.identifier == coinId);
}
