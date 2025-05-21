// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_logger.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gift_unwrap_service_provider.c.g.dart';

class GiftUnwrapService {
  GiftUnwrapService({
    required String privateKey,
    required IonConnectSealService sealService,
    required IonConnectGiftWrapService giftWrapService,
    this.logger,
  })  : _privateKey = privateKey,
        _giftWrapService = giftWrapService,
        _sealService = sealService;

  final String _privateKey;
  final IonConnectLogger? logger;
  final IonConnectSealService _sealService;
  final IonConnectGiftWrapService _giftWrapService;

  Future<EventMessage> unwrap(EventMessage giftWrap) async {
    try {
      final rumor = await unwrapGiftSharedIsolate.compute(unwrapGiftFn, [
        _giftWrapService,
        _sealService,
        _privateKey,
        giftWrap.content,
        giftWrap.pubkey,
        logger,
      ]);

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
    sealService: sealService,
    giftWrapService: giftWrapService,
    privateKey: eventSigner.privateKey,
  );
}

final unwrapGiftSharedIsolate = IsolateManager.createShared(
  useWorker: true,
  workerMappings: {
    unwrapGiftFn: 'unwrapGiftFn',
  },
);

@pragma('vm:entry-point')
Future<EventMessage> unwrapGiftFn(List<dynamic> args) async {
  final giftWrapService = args[0] as IonConnectGiftWrapService;
  final sealService = args[1] as IonConnectSealService;
  final privateKey = args[2] as String;
  final content = args[3] as String;
  final senderPubkey = args[4] as String;
  final logger = args[5] as IonConnectLogger?;

  // It is isolated, so we need to initialize it again for sign verification
  IonConnect.initialize(logger);

  final seal = await giftWrapService.decodeWrap(
    privateKey: privateKey,
    content: content,
    senderPubkey: senderPubkey,
  );

  final rumor = await sealService.decodeSeal(
    seal.content,
    seal.pubkey,
    privateKey,
  );

  // Check if:
  // 1. The seal is valid (validated signature)
  // 2. The seal pubkey is the same as the rumor pubkey
  // 3. The seal masterPubkey is the same as the rumor masterPubkey
  if (seal.sig != null &&
      await seal.validate() &&
      seal.pubkey == rumor.pubkey &&
      seal.masterPubkey == rumor.masterPubkey) {
    return rumor;
  } else {
    throw DecodeE2EMessageException(rumor.id);
  }
}
