// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/current_nfts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

typedef NftCacheKey = ({String contract, String tokenId});

final nftDetailsProvider =
    FutureProvider.autoDispose.family<NftData, NftCacheKey>((ref, tokenKey) async {
  final nfts = await ref.watch(currentNftsProvider.future);

  return nfts.firstWhere(
    (nft) => nft.contract == tokenKey.contract && nft.tokenId == tokenKey.tokenId,
  );
});
