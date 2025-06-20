// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_asset_handler.c.g.dart';

class WalletAssetHandler extends GlobalSubscriptionEncryptedEventMessageHandler {
  WalletAssetHandler(
    this.currentPubkey,
    this.walletViewsService,
    this.transactionsRepository,
    this.requestAssetsRepository,
  );

  final String currentPubkey;
  final WalletViewsService walletViewsService;
  final TransactionsRepository transactionsRepository;
  final RequestAssetsRepository requestAssetsRepository;

  @override
  bool canHandle({required IonConnectGiftWrapEntity entity}) {
    return entity.data.kinds.containsDeep([WalletAssetEntity.kind.toString()]);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    final message = WalletAssetEntity.fromEventMessage(rumor);

    // Since the current user is the recipient,
    // we need to replace his pubkey inside the asset
    // with the sender's pubkey to maintain accurate information about the sender.
    final adjustedMessage = message.data.pubkey == currentPubkey
        ? message.copyWith(
            data: message.data.copyWith(pubkey: message.masterPubkey),
          )
        : message;

    final walletViews = walletViewsService.lastEmitted.isNotEmpty
        ? walletViewsService.lastEmitted
        : await walletViewsService.walletViews.first;
    await transactionsRepository.saveEntities([adjustedMessage], walletViews);

    final requestJson = adjustedMessage.data.request;
    if (requestJson != null) {
      try {
        final decodedJson = jsonDecode(requestJson) as Map;

        final requestId = decodedJson['id'] as String;
        final txHash = adjustedMessage.data.content.txHash;
        await requestAssetsRepository.markRequestAsPaid(requestId, txHash);
      } catch (e) {
        Logger.error('Failed to parse request JSON: $e');
      }
    }
  }
}

@riverpod
Future<WalletAssetHandler?> walletAssetHandler(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final walletViewsService = await ref.watch(walletViewsServiceProvider.future);
  final transactionsRepository = await ref.watch(transactionsRepositoryProvider.future);
  final requestAssetsRepository = ref.watch(requestAssetsRepositoryProvider);

  if (currentPubkey == null) {
    return null;
  }

  return WalletAssetHandler(
    currentPubkey,
    walletViewsService,
    transactionsRepository,
    requestAssetsRepository,
  );
}
