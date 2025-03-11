// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/domain/nfts/use_cases/load_nfts_use_case.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/services/command/command.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final walletNftsViewModelProvider = Provider.autoDispose(
  (ref) {
    final currentWalletViewId = ref.watch(currentWalletViewIdProvider).valueOrNull;

    final viewModel = WalletNftsViewModel(
      walletViewId: currentWalletViewId ?? '',
      loadNftsUseCase: ref.watch(loadNftsUseCaseProvider),
    );

    ref.onDispose(viewModel._dispose);

    return viewModel;
  },
);

class WalletNftsViewModel {
  WalletNftsViewModel({
    required LoadNftsUseCase loadNftsUseCase,
    required String walletViewId,
  })  : _walletViewId = walletViewId,
        _loadNftsUseCase = loadNftsUseCase {
    _initializeCommands();
    loadNftsCommand.execute();
  }

  final String _walletViewId;
  final LoadNftsUseCase _loadNftsUseCase;

  late final Command<void, List<NftData>> loadNftsCommand;
  late final StateCommand<String> searchQueryCommand;
  late final StateCommand<Set<String>> selectedNetworksCommand;
  late final ValueListenable<List<NftData>> filteredNfts;
  late final ValueListenable<Set<String>> availableNetworks;

  void _initializeCommands() {
    loadNftsCommand = Command.createAsyncNoParam(
      _loadNfts,
      initialValue: [],
    );

    searchQueryCommand = stateCommand('');
    selectedNetworksCommand = stateCommand({});
    availableNetworks = loadNftsCommand.map((nfts) => nfts.map((nft) => nft.network).toSet());
    filteredNfts = loadNftsCommand.combineLatest3(
      searchQueryCommand,
      selectedNetworksCommand,
      _filterNfts,
    );
  }

  Future<List<NftData>> _loadNfts() async {
    return _loadNftsUseCase(walletViewId: _walletViewId);
  }

  List<NftData> _filterNfts(List<NftData> nfts, String query, Set<String> selectedNetworks) {
    return nfts
        .where((nft) => nft.symbol.toLowerCase().contains(query))
        .where((nft) => selectedNetworks.isEmpty || selectedNetworks.contains(nft.symbol))
        .toList();
  }

  void _dispose() {
    selectedNetworksCommand.dispose();
    searchQueryCommand.dispose();
    loadNftsCommand.dispose();
  }
}
