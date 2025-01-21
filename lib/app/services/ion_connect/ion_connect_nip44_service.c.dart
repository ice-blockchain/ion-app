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

part 'ion_connect_nip44_service.c.g.dart';

@Riverpod(keepAlive: true)
Future<IonConnectNip44Service> ionConnectNip44Service(Ref ref) async {
  final currentUserPubkey = await ref.read(currentPubkeySelectorProvider.future);
  final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return IonConnectNip44Service(
    eventSigner: eventSigner,
    currentUserPubkey: currentUserPubkey,
  );
}

class IonConnectNip44Service {
  IonConnectNip44Service({required this.eventSigner, required this.currentUserPubkey});

  final EventSigner eventSigner;
  final String currentUserPubkey;

  Future<String> decryptMessage(String message) async {
    final conversationKey = Nip44.deriveConversationKey(
      await Ed25519KeyStore.getSharedSecret(
        privateKey: eventSigner.privateKey,
        publicKey: currentUserPubkey,
      ),
    );

    final decryptedMessage = await Nip44.decryptMessage(
      message,
      eventSigner.privateKey,
      currentUserPubkey,
      customConversationKey: conversationKey,
    );

    return decryptedMessage;
  }

  Future<String> encryptMessage(String message) async {
    final conversationKey = Nip44.deriveConversationKey(
      await Ed25519KeyStore.getSharedSecret(
        privateKey: eventSigner.privateKey,
        publicKey: currentUserPubkey,
      ),
    );

    final decryptedMessage = await Nip44.encryptMessage(
      message,
      eventSigner.privateKey,
      currentUserPubkey,
      customConversationKey: conversationKey,
    );

    return decryptedMessage;
  }
}
