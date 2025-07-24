// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.r.dart';
import 'package:ion/app/features/core/providers/wallets_provider.r.dart';
import 'package:ion/app/features/wallets/data/mappers/nft_mapper.dart';
import 'package:ion/app/features/wallets/data/repository/coins_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_comparator.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/sync_wallet_views_coins_service.r.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_live_updater.r.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.f.dart';
import 'package:ion/app/features/wallets/model/coins_group.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.f.dart';
import 'package:ion/app/features/wallets/utils/crypto_amount_parser.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_update_wallet_view_request_builder.dart';
part 'wallet_view_parser.dart';
part 'wallet_views_service.r.g.dart';

@riverpod
Future<WalletViewsService> walletViewsService(Ref ref) async {
  final (
    identity,
    wallets,
    mainWallet,
    transactionsRepo,
    syncService,
    liveUpdater,
  ) = await (
    ref.watch(ionIdentityClientProvider.future),
    ref.watch(walletsNotifierProvider.future),
    ref.watch(mainWalletProvider.future),
    ref.watch(transactionsRepositoryProvider.future),
    ref.watch(syncWalletViewCoinsServiceProvider.future),
    ref.watch(walletViewsLiveUpdaterProvider.future),
  ).wait;

  final service = WalletViewsService(
    identity,
    wallets,
    mainWallet,
    ref.watch(walletViewParserProvider),
    ref.watch(networksRepositoryProvider),
    transactionsRepo,
    syncService,
    liveUpdater,
  );

  ref.onDispose(service.dispose);

  return service;
}

class WalletViewsService {
  WalletViewsService(
    this._identity,
    this._userWallets,
    this._mainUserWallet,
    this._walletViewParser,
    this._networksRepository,
    this._transactionsRepository,
    this._syncWalletViewCoinsService,
    this._liveUpdater,
  );

  final List<Wallet> _userWallets;
  final Wallet? _mainUserWallet;
  final IONIdentityClient _identity;
  final WalletViewParser _walletViewParser;
  final NetworksRepository _networksRepository;
  final TransactionsRepository _transactionsRepository;
  final SyncWalletViewCoinsService _syncWalletViewCoinsService;
  final WalletViewsLiveUpdater _liveUpdater;

  final StreamController<List<WalletViewData>> _walletViewsController =
      StreamController.broadcast();

  Stream<List<WalletViewData>> get walletViews => _walletViewsController.stream;
  List<WalletViewData> _originWalletViews = [];
  List<WalletViewData> _modifiedWalletViews = [];

  List<WalletViewData> get lastEmitted => _modifiedWalletViews;

  StreamSubscription<List<WalletViewData>>? _updatesSubscription;

  Future<List<WalletViewData>> fetch() async {
    final shortViews = await _identity.wallets.getWalletViews();

    final viewsDetailsDTO = await Future.wait(
      shortViews.map((e) => _identity.wallets.getWalletView(e.id)),
    );
    final networks = await _networksRepository.getAllAsMap();
    final mainWalletViewId = viewsDetailsDTO.isEmpty
        ? '' // if there no wallet views, we haven't the main one
        : viewsDetailsDTO.reduce((a, b) => a.createdAt.isBefore(b.createdAt) ? a : b).id;

    _originWalletViews = await viewsDetailsDTO
        .map(
          (viewDTO) => _walletViewParser.parse(
            viewDTO,
            networks,
            isMainWalletView: viewDTO.id == mainWalletViewId,
          ),
        )
        .wait
        .then((result) => result.toList());
    _updateEmittedWalletViews(walletViews: _originWalletViews);

    return _originWalletViews;
  }

  void _updateEmittedWalletViews({
    List<WalletViewData>? walletViews,
    bool refreshSubscriptions = true,
    bool updatePeriodicCoinsSync = true,
  }) {
    if (updatePeriodicCoinsSync) {
      final coins = _originWalletViews.expand((wv) => wv.coins).map((c) => c.coin).toList();
      _syncWalletViewCoinsService.start(coins);
    }

    if (walletViews != null) {
      _modifiedWalletViews = walletViews;
    }

    _walletViewsController.add(_modifiedWalletViews);

    if (refreshSubscriptions) _refreshUpdateSubscription();
  }

  void _refreshUpdateSubscription() {
    if (_originWalletViews.isEmpty) return;

    Logger.info(
        'WalletViewsService: Setting up live updates for ${_originWalletViews.length} wallet views');

    _updatesSubscription?.cancel();
    _updatesSubscription = _liveUpdater.watchWalletViews(_originWalletViews).listen((updatedViews) {
      Logger.info('WalletViewsService: Received updated wallet views from live updater');

      if (_originWalletViews.isEmpty) return;

      _updateEmittedWalletViews(
        walletViews: updatedViews,
        refreshSubscriptions: false,
        updatePeriodicCoinsSync: false,
      );
    });
  }

  Future<WalletViewData> create(String name) async {
    final request = _CreateUpdateRequestBuilder().build(name: name);
    final networks = await _networksRepository.getAllAsMap();
    final newWalletView = await _identity.wallets.createWalletView(request).then(
          (viewDTO) => _walletViewParser.parse(viewDTO, networks, isMainWalletView: false),
        );

    _originWalletViews = [..._originWalletViews, newWalletView];
    _updateEmittedWalletViews(walletViews: _originWalletViews);

    return newWalletView;
  }

  Future<WalletViewData> update({
    required WalletViewData walletView,
    String? updatedName,
    List<CoinData>? updatedCoinsList,
  }) async {
    final networks = await _networksRepository.getAllAsMap();
    final request = _CreateUpdateRequestBuilder().build(
      name: updatedName,
      walletView: walletView,
      coinsList: updatedCoinsList,
      userWallets: _userWallets,
      mainUserWallet: _mainUserWallet,
    );

    final updatedWalletView = await _identity.wallets.updateWalletView(walletView.id, request).then(
          (viewDTO) => _walletViewParser.parse(
            viewDTO,
            networks,
            isMainWalletView: walletView.isMainWalletView,
          ),
        );

    final index = _originWalletViews.indexWhere((w) => w.id == walletView.id);

    if (index != -1) {
      _originWalletViews[index] = updatedWalletView;
    } else {
      _originWalletViews.add(updatedWalletView);
    }

    _updateEmittedWalletViews(walletViews: _originWalletViews);

    return updatedWalletView;
  }

  Future<void> delete({required String walletViewId}) async {
    await _identity.wallets.deleteWalletView(walletViewId);

    unawaited(
      _transactionsRepository.remove(
        walletViewIds: [walletViewId],
      ),
    );

    _originWalletViews = _originWalletViews.where((view) => view.id != walletViewId).toList();

    _updateEmittedWalletViews(walletViews: _originWalletViews);
  }

  void dispose() {
    _walletViewsController.close();
    _updatesSubscription?.cancel();
  }
}
