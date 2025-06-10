// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/models/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/nfts_repository_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nft_details_provider.c.g.dart';

@riverpod
NftData? nftDetails(Ref ref, NftIdentifier identifier) {
  final nftsRepository = ref.watch(nftsRepositoryProvider);

  return nftsRepository.getNftByIdentifier(identifier);
}
