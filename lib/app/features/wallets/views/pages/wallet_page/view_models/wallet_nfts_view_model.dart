// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/domain/nfts/load_nfts_use_case.dart';
import 'package:ion/app/features/wallets/domain/nfts/nft_network_filter_manager.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/command/command.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final walletNftsViewModelProvider = Provider.autoDispose(
  (ref) {
    final currentWalletViewId = ref.watch(currentWalletViewIdProvider).valueOrNull;
    final nftFilterService = ref.watch(nftNetworkFilterManagerProvider);

    final viewModel = WalletNftsViewModel(
      walletViewId: currentWalletViewId ?? '',
      loadNftsUseCase: ref.watch(loadNftsUseCaseProvider),
      nftFilterService: nftFilterService,
    );

    ref.onDispose(viewModel._dispose);

    return viewModel;
  },
);

class WalletNftsViewModel {
  WalletNftsViewModel({
    required String walletViewId,
    required LoadNftsUseCase loadNftsUseCase,
    required NftNetworkFilterManager nftFilterService,
  })  : _walletViewId = walletViewId,
        _loadNftsUseCase = loadNftsUseCase,
        _nftFilterService = nftFilterService {
    _initializeCommands();
    _setupCommandListeners();
    loadNftsCommand.execute();
  }

  final String _walletViewId;
  final LoadNftsUseCase _loadNftsUseCase;
  final NftNetworkFilterManager _nftFilterService;

  late final Command<void, List<NftData>> loadNftsCommand;
  late final StateCommand<String> searchQueryCommand;
  late final ValueListenable<List<NftData>> filteredNfts;

  void _initializeCommands() {
    loadNftsCommand = Command.createAsyncNoParam(
      _loadNfts,
      initialValue: [],
    );

    searchQueryCommand = stateCommand('');
    filteredNfts = loadNftsCommand.combineLatest3(
      searchQueryCommand,
      _nftFilterService.selectedNetworksCommand,
      _filterNfts,
    );
  }

  void _setupCommandListeners() {
    loadNftsCommand.listen((nfts, _) {
      _nftFilterService.availableNetworksCommand(nfts.map((nft) => nft.network).toSet());
    });
  }

  Future<List<NftData>> _loadNfts() async {
    return _loadNftsUseCase(walletViewId: _walletViewId);
  }

  List<NftData> _filterNfts(List<NftData> nfts, String query, Set<String> selectedNetworks) {
    return nfts
        .where((nft) => nft.symbol.toLowerCase().contains(query))
        .where((nft) => selectedNetworks.isEmpty || selectedNetworks.contains(nft.network))
        .toList();
  }

  void _dispose() {
    searchQueryCommand.dispose();
    loadNftsCommand.dispose();
  }
}
