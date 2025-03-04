// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfts_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<NftData>> nftsData(Ref ref) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    return [];
  }
  // TODO: Not implemented
  // final currentWalletId = await ref.watch(currentWalletViewIdProvider.future);
  // final ionIdentity = await ref.watch(ionIdentityProvider.future);
  // final walletNfts =
  //     await ionIdentity(username: currentUser).wallets.getWalletNfts(currentWalletId);

  final nfts = List.generate(
    5,
    (_) => const NftData(
      collectionName: 'COLLECTION NULL',
      identifier: 0,
      price: 0,
      network: mockedNetwork,
      currency: 'CURRENCY NULL',
      iconUrl: 'ICONURL NULL',
      currencyIconUrl: 'CURRENCYICONURL NULL',
      description: 'DESCRIPTION NULL',
      tokenStandard: 'TOKENSTANDARD NULL',
      contractAddress: 'CONTRACTADDRESS NULL',
      rank: 0,
      asset: 'ASSET NULL',
    ),
  );
  return nfts;
}

@riverpod
Future<NftData> nftById(Ref ref, {required int coinId}) async {
  final coins = await ref.watch(nftsDataProvider.future);

  return coins.firstWhere((NftData nft) => nft.identifier == coinId);
}
