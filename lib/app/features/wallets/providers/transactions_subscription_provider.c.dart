// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/entities_syncer_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/wallets/data/models/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/data/models/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/providers/repository/request_assets_repository.c.dart';
import 'package:ion/app/features/wallets/providers/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_views/wallet_views_service.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_initializer_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_subscription_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<void> transactionsSubscription(Ref ref) async {
  // Wait until all necessary wallets components are initialized
  await ref.watch(walletsInitializerNotifierProvider.future);

  final authState = await ref.watch(authProvider.future);

  if (!authState.isAuthenticated) {
    return;
  }

  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final transactionsRepository = ref.watch(transactionsRepositoryProvider).valueOrNull;
  final requestAssetsRepository = ref.watch(requestAssetsRepositoryProvider);
  final onboardingComplete = ref.watch(onboardingCompleteProvider).valueOrNull;
  final walletViewsService = ref.watch(walletViewsServiceProvider).valueOrNull;
  final giftUnwrapService = await ref.watch(giftUnwrapServiceProvider.future);

  if (currentPubkey == null ||
      transactionsRepository == null ||
      walletViewsService == null ||
      // otherwise relays might not be assigned yet or delegation is not done
      !onboardingComplete.falseOrValue) {
    return;
  }

  final requestFilter = RequestFilter(
    kinds: const [IonConnectGiftWrapEntity.kind],
    since: DateTime.now().subtract(const Duration(days: 2)).microsecondsSinceEpoch,
    tags: {
      '#k': [
        FundsRequestEntity.kind.toString(),
        WalletAssetEntity.kind.toString(),
      ],
      '#p': [currentPubkey],
    },
  );

  await ref.watch(entitiesSyncerNotifierProvider('transactions').notifier).syncEvents(
    requestFilters: [requestFilter],
    saveCallback: (eventMessage) => _saveEvent(
      eventMessage: eventMessage,
      currentPubkey: currentPubkey,
      giftUnwrapService: giftUnwrapService,
      walletViewsService: walletViewsService,
      transactionsRepository: transactionsRepository,
      requestAssetsRepository: requestAssetsRepository,
    ),
    maxCreatedAtBuilder: () async {
      final transactionLastCreatedAt = await transactionsRepository.getLastCreatedAt();
      final requestLastCreatedAt = await requestAssetsRepository.getLastCreatedAt();
      return _getEarliestDateTime(transactionLastCreatedAt, requestLastCreatedAt);
    },
    minCreatedAtBuilder: (since) async {
      final transactionFirstCreatedAt = await transactionsRepository.firstCreatedAt(after: since);
      final requestFirstCreatedAt = await requestAssetsRepository.firstCreatedAt(after: since);
      return _getLatestDateTime(transactionFirstCreatedAt, requestFirstCreatedAt);
    },
    overlap: const Duration(days: 2),
  );

  final requestMessage = RequestMessage()..addFilter(requestFilter);

  final events = ref.watch(ionConnectEventsSubscriptionProvider(requestMessage));

  final subscription = events.listen(
    (eventMessage) => _saveEvent(
      eventMessage: eventMessage,
      currentPubkey: currentPubkey,
      giftUnwrapService: giftUnwrapService,
      walletViewsService: walletViewsService,
      transactionsRepository: transactionsRepository,
      requestAssetsRepository: requestAssetsRepository,
    ),
  );

  ref.onDispose(subscription.cancel);
}

/// Returns the earliest datetime between two optional datetimes.
/// If both are null, returns null.
/// If only one is null, returns the non-null one.
DateTime? _getEarliestDateTime(DateTime? first, DateTime? second) {
  if (first == null) return second;
  if (second == null) return first;
  return first.isBefore(second) ? first : second;
}

/// Returns the latest datetime between two optional datetimes.
/// If both are null, returns null.
/// If only one is null, returns the non-null one.
DateTime? _getLatestDateTime(DateTime? first, DateTime? second) {
  if (first == null) return second;
  if (second == null) return first;
  return first.isAfter(second) ? first : second;
}

Future<void> _saveEvent({
  required String currentPubkey,
  required EventMessage eventMessage,
  required GiftUnwrapService giftUnwrapService,
  required WalletViewsService walletViewsService,
  required TransactionsRepository transactionsRepository,
  required RequestAssetsRepository requestAssetsRepository,
}) async {
  try {
    final rumor = await giftUnwrapService.unwrap(eventMessage);

    switch (rumor.kind) {
      case WalletAssetEntity.kind:
        await _handleWalletAssetEntity(
          rumor: rumor,
          currentPubkey: currentPubkey,
          walletViewsService: walletViewsService,
          transactionsRepository: transactionsRepository,
          requestAssetsRepository: requestAssetsRepository,
        );
      case FundsRequestEntity.kind:
        await _handleFundsRequestEntity(
          rumor: rumor,
          requestAssetsRepository: requestAssetsRepository,
        );
    }
  } on Exception catch (ex) {
    Logger.error('Caught error in subscription: $ex');
  }
}

/// Handle a WalletAssetEntity event
Future<void> _handleWalletAssetEntity({
  required EventMessage rumor,
  required String currentPubkey,
  required WalletViewsService walletViewsService,
  required TransactionsRepository transactionsRepository,
  required RequestAssetsRepository requestAssetsRepository,
}) async {
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

/// Handle a FundsRequestEntity event
Future<void> _handleFundsRequestEntity({
  required EventMessage rumor,
  required RequestAssetsRepository requestAssetsRepository,
}) async {
  final request = FundsRequestEntity.fromEventMessage(rumor);

  final updatedData = request.data.copyWith(request: jsonEncode(rumor.jsonPayload));
  final updatedRequest = request.copyWith(data: updatedData);

  await requestAssetsRepository.saveRequestAsset(updatedRequest);

  Logger.info('Saved funds request ${request.id} with original event JSON');
}
