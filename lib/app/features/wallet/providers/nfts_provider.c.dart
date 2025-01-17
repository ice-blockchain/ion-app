// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfts_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<NftData>> nftsData(Ref ref) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    return [];
  }
  final currentWalletId = await ref.watch(currentWalletViewIdProvider.future);

  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  final walletNfts =
      await ionIdentity(username: currentUser).wallets.getWalletNfts(currentWalletId);

  final coins = [
    // ignore: unused_local_variable
    for (final (index, nft) in walletNfts.nfts.indexed)
      // TODO: get actual NFT data
      const NftData(
        collectionName: 'COLLECTION NULL',
        identifier: 0,
        price: 0,
        currency: 'CURRENCY NULL',
        iconUrl: 'ICONURL NULL',
        networkType: NetworkType.all,
        currencyIconUrl: 'CURRENCYICONURL NULL',
        description: 'DESCRIPTION NULL',
        network: 'NETWORK NULL',
        tokenStandard: 'TOKENSTANDARD NULL',
        contractAddress: 'CONTRACTADDRESS NULL',
        rank: 0,
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
