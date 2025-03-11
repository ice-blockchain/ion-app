// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/nfts_repository.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final loadNftsUseCaseProvider = Provider.autoDispose((ref) {
  return LoadNftsUseCase(
    nftsRepository: ref.watch(nftsRepositoryProvider),
    walletViewsService: ref.watch(walletViewsServiceProvider).valueOrNull!,
  );
});

class LoadNftsUseCase {
  LoadNftsUseCase({
    required NftsRepository nftsRepository,
    required WalletViewsService walletViewsService,
  })  : _nftsRepository = nftsRepository,
        _walletViewsService = walletViewsService;

  final NftsRepository _nftsRepository;
  final WalletViewsService _walletViewsService;

  Future<List<NftData>> call({
    required String walletViewId,
  }) async {
    final walletViews = await _walletViewsService.fetch();
    final currentWalletView = walletViews.firstWhereOrNull((wv) => wv.id == walletViewId);
    if (currentWalletView == null) {
      return [];
    }

    final walletIds = _extractUniqueWalletIds(currentWalletView);
    return _loadNftsForWallets(walletViewId, walletIds);
  }

  Set<String> _extractUniqueWalletIds(WalletViewData walletView) {
    return walletView.coins.map((c) => c.walletId).nonNulls.toSet();
  }

  Future<List<NftData>> _loadNftsForWallets(String walletViewId, Set<String> walletIds) async {
    final nfts = await walletIds
        .map(
          (walletId) => _nftsRepository
              .getNfts(
                walletViewId: walletViewId,
                walletId: walletId,
              )
              .onError((_, __) => []),
        )
        .wait;

    return nfts.expand((nft) => nft).toList();
  }
}
