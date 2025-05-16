import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gift_unwrap_service_provider.c.g.dart';

class GiftUnwrapService {
  GiftUnwrapService({
    required String privateKey,
    required IonConnectSealService sealService,
    required IonConnectGiftWrapService giftWrapService,
  })  : _privateKey = privateKey,
        _giftWrapService = giftWrapService,
        _sealService = sealService;

  final String _privateKey;
  final IonConnectSealService _sealService;
  final IonConnectGiftWrapService _giftWrapService;

  Future<EventMessage> unwrap(EventMessage giftWrap) async {
    try {
      final rumor = await compute(
        (args) async {
          final seal = await args.$1.decodeWrap(
            privateKey: args.$3,
            content: args.$4,
            senderPubkey: args.$5,
          );

          return args.$2.decodeSeal(
            seal.content,
            seal.pubkey,
            args.$3,
          );
        },
        (_giftWrapService, _sealService, _privateKey, giftWrap.content, giftWrap.pubkey),
      );

      return rumor;
    } catch (e) {
      throw DecodeE2EMessageException(giftWrap.id);
    }
  }
}

@riverpod
Future<GiftUnwrapService> giftUnwrapService(Ref ref) async {
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
  final sealService = await ref.watch(ionConnectSealServiceProvider.future);
  final giftWrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  return GiftUnwrapService(
    privateKey: eventSigner.privateKey,
    sealService: sealService,
    giftWrapService: giftWrapService,
  );
}
