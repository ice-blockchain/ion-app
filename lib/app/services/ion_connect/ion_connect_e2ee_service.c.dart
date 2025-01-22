// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:nip44/nip44.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_e2ee_service.c.g.dart';

@Riverpod(keepAlive: true)
Future<IonConnectE2eeService> ionConnectE2eeService(Ref ref) async {
  final currentUserPubkey = await ref.read(currentPubkeySelectorProvider.future);
  final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return IonConnectE2eeService(
    eventSigner: eventSigner,
    currentUserPubkey: currentUserPubkey,
  );
}

class IonConnectE2eeService {
  IonConnectE2eeService({required this.eventSigner, required this.currentUserPubkey});

  final EventSigner eventSigner;
  final String currentUserPubkey;

  Future<String> decryptMessage(String message, {String? publicKey}) async {
    final conversationKey = Nip44.deriveConversationKey(
      await Ed25519KeyStore.getSharedSecret(
        privateKey: eventSigner.privateKey,
        publicKey: publicKey ?? currentUserPubkey,
      ),
    );

    final decryptedMessage = await Nip44.decryptMessage(
      message,
      eventSigner.privateKey,
      publicKey ?? currentUserPubkey,
      customConversationKey: conversationKey,
    );

    return decryptedMessage;
  }

  Future<String> encryptMessage(String message, {String? publicKey}) async {
    final conversationKey = Nip44.deriveConversationKey(
      await Ed25519KeyStore.getSharedSecret(
        privateKey: eventSigner.privateKey,
        publicKey: publicKey ?? currentUserPubkey,
      ),
    );

    final decryptedMessage = await Nip44.encryptMessage(
      message,
      eventSigner.privateKey,
      publicKey ?? currentUserPubkey,
      customConversationKey: conversationKey,
    );

    return decryptedMessage;
  }
}
