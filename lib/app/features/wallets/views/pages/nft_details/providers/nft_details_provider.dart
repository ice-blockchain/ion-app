// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/nfts_repository.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final nftDetailsProvider = FutureProvider.autoDispose.family<NftData, NftCacheKey>((ref, tokenKey) {
  final repository = ref.watch(nftsRepositoryProvider);

  return repository.getNft(tokenKey);
});
