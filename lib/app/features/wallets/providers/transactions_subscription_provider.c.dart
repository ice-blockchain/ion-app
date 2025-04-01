// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_subscription_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<void> transactionsSubscription(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final transactionsRepository = ref.watch(transactionsRepositoryProvider).valueOrNull;
  final eventSigner = ref.watch(currentUserIonConnectEventSignerProvider).valueOrNull;
  final sealService = ref.watch(ionConnectSealServiceProvider).valueOrNull;
  final giftWrapService = ref.watch(ionConnectGiftWrapServiceProvider).valueOrNull;

  if (currentPubkey == null ||
      eventSigner == null ||
      sealService == null ||
      giftWrapService == null ||
      transactionsRepository == null) {
    return;
  }

  final since = await transactionsRepository.lastCreatedAt();

  final requestMessage = RequestMessage(
    filters: [
      RequestFilter(
        kinds: const [IonConnectGiftWrapServiceImpl.kind],
        since: since?.subtract(const Duration(days: 2)),
        tags: {
          '#k': ['1755', WalletAssetEntity.kind.toString()],
          '#p': [currentPubkey],
        },
      ),
    ],
  );

  final events = ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
    requestMessage,
    subscriptionBuilder: (requestMessage, relay) {
      final subscription = relay.subscribe(requestMessage);

      try {
        ref.onDispose(() => relay.unsubscribe(subscription.id));
      } on Exception catch (ex) {
        Logger.error('Caught error during unsubscribing from relay: $ex');
      }

      return subscription.messages;
    },
  );

  final subscription = events.listen((eventMessage) async {
    try {
      final rumor = await _unwrapGift(
        giftWrap: eventMessage,
        privateKey: eventSigner.privateKey,
        sealService: sealService,
        giftWrapService: giftWrapService,
      );

      if (rumor != null) {
        final message = WalletAssetEntity.fromEventMessage(rumor);
        await transactionsRepository.saveEntities([message]);
      }
    } on Exception catch (ex) {
      Logger.error('Caught error in subscription: $ex');
    }
  });

  ref.onDispose(subscription.cancel);
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
