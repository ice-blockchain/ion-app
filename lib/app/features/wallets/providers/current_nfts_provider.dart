// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final currentNftsProvider = FutureProvider.autoDispose((ref) async {
  final walletViewData = await ref.watch(currentWalletViewDataProvider.future);

  final nfts =
      await walletViewData.nfts.map((nft) => ref.watch(_nftDetailsProvider(nft).future)).wait;

  return nfts;
});

final _nftDetailsProvider = FutureProvider.family<NftData, NftData>((ref, nftData) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(nftData.tokenUri);

  final data = response.data;
  if (response.statusCode != 200 || data == null) {
    throw Exception('Failed to fetch NFT data');
  }

  final description = data['description'] as String;
  final image = data['image'] as String;

  return nftData.copyWith(
    description: description,
    tokenUri: image.replaceFirst('ipfs://', 'https://ipfs.io/ipfs/'),
  );
});
