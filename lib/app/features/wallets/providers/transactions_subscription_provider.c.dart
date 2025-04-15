// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_complete_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_initializer_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
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
  final eventSigner = ref.watch(currentUserIonConnectEventSignerProvider).valueOrNull;
  final sealService = ref.watch(ionConnectSealServiceProvider).valueOrNull;
  final giftWrapService = ref.watch(ionConnectGiftWrapServiceProvider).valueOrNull;
  final onboardingComplete = ref.watch(onboardingCompleteProvider).valueOrNull;

  if (currentPubkey == null ||
      eventSigner == null ||
      sealService == null ||
      giftWrapService == null ||
      transactionsRepository == null ||
      // otherwise relays might be not assigned yet
      !onboardingComplete.falseOrValue) {
    return;
  }

  final transactionLastCreatedAt = await transactionsRepository.getLastCreatedAt();
  final requestLastCreatedAt = await requestAssetsRepository.getLastCreatedAt();

  final lastCreatedAt = _getEarliestDateTime(transactionLastCreatedAt, requestLastCreatedAt);
  final since = lastCreatedAt?.subtract(2.days);

  final requestMessage = RequestMessage(
    filters: [
      RequestFilter(
        kinds: const [IonConnectGiftWrapServiceImpl.kind],
        since: since,
        tags: {
          '#k': [
            FundsRequestEntity.kind.toString(),
            WalletAssetEntity.kind.toString(),
          ],
          '#p': [currentPubkey],
        },
      ),
    ],
  );

  final events = ref.watch(ionConnectEventsSubscriptionProvider(requestMessage));

  final subscription = events.listen((eventMessage) async {
    try {
      final rumor = await _unwrapGift(
        giftWrap: eventMessage,
        privateKey: eventSigner.privateKey,
        sealService: sealService,
        giftWrapService: giftWrapService,
      );

      if (rumor != null) {
        switch (rumor.kind) {
          case WalletAssetEntity.kind:
            final message = WalletAssetEntity.fromEventMessage(rumor);
            await transactionsRepository.saveEntities([message]);
          case FundsRequestEntity.kind:
            final request = FundsRequestEntity.fromEventMessage(rumor);
            await requestAssetsRepository.saveRequestAsset(request);
        }
      }
    } on Exception catch (ex) {
      Logger.error('Caught error in subscription: $ex');
    }
  });

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

Future<EventMessage?> _unwrapGift({
  required EventMessage giftWrap,
  required String privateKey,
  required IonConnectSealService sealService,
  required IonConnectGiftWrapService giftWrapService,
}) async {
  try {
    final seal = await giftWrapService.decodeWrap(
      privateKey: privateKey,
      content: giftWrap.content,
      senderPubkey: giftWrap.pubkey,
    );

    return await sealService.decodeSeal(
      seal.content,
      seal.pubkey,
      privateKey,
    );
  } catch (e) {
    throw DecodeE2EMessageException(giftWrap.id);
  }
}
