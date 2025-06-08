// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/models/nft_data.c.dart';
import 'package:ion/app/features/wallets/data/repository/nfts_repository.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_nfts_provider.c.g.dart';

@riverpod
Future<List<NftData>> currentNfts(Ref ref) async {
  final nftsRepository = ref.watch(nftsRepositoryProvider);

  final walletViewData = await ref.watch(currentWalletViewDataProvider.future);

  final nfts = await walletViewData.nfts.map(nftsRepository.getNftExtras).wait;

  return nfts;
}
