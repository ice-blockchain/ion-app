// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:nip44/nip44.dart';
import 'package:pinenacl/tweetnacl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_message_service.c.g.dart';

@Riverpod(keepAlive: true)
Future<EncryptedMessageService> encryptedMessageService(Ref ref) async {
  final currentUserPubkey = ref.read(currentPubkeySelectorProvider);
  final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return EncryptedMessageService(
    eventSigner: eventSigner,
    currentUserPubkey: currentUserPubkey,
  );
}

class EncryptedMessageService {
  EncryptedMessageService({required this.eventSigner, required this.currentUserPubkey});

  final EventSigner eventSigner;
  final String currentUserPubkey;

  Future<String> encryptMessage(String message, {String? publicKey, String? privateKey}) async {
    final x25519Pk = Uint8List.fromList(List.filled(32, 0));
    final ed25519Pk = Uint8List.fromList(hex.decode(publicKey ?? currentUserPubkey));
    TweetNaClExt.crypto_sign_ed25519_pk_to_x25519_pk(x25519Pk, ed25519Pk);
    final x25519PublicKey = hex.encode(x25519Pk);

    final x25519Sk = Uint8List.fromList(List.filled(32, 0));
    final ed25519Sk = Uint8List.fromList(hex.decode(privateKey ?? eventSigner.privateKey));
    TweetNaClExt.crypto_sign_ed25519_sk_to_x25519_sk(x25519Sk, ed25519Sk);
    final x25519PrivateKey = hex.encode(x25519Sk);

    final conversationKey = await Ed25519KeyStore.getX25519SharedSecret(
      privateKey: x25519PrivateKey,
      publicKey: x25519PublicKey,
    );

    final decryptedMessage = await Nip44.encryptMessage(
      message,
      x25519PrivateKey,
      x25519PublicKey,
      customConversationKey: conversationKey,
    );

    return decryptedMessage;
  }

  Future<String> decryptMessage(String message, {String? publicKey, String? privateKey}) async {
    final x25519Pk = Uint8List.fromList(List.filled(32, 0));
    final ed25519Pk = Uint8List.fromList(hex.decode(publicKey ?? currentUserPubkey));
    TweetNaClExt.crypto_sign_ed25519_pk_to_x25519_pk(x25519Pk, ed25519Pk);
    final x25519PublicKey = hex.encode(x25519Pk);

    final x25519Sk = Uint8List.fromList(List.filled(32, 0));
    final ed25519Sk = Uint8List.fromList(hex.decode(privateKey ?? eventSigner.privateKey));
    TweetNaClExt.crypto_sign_ed25519_sk_to_x25519_sk(x25519Sk, ed25519Sk);
    final x25519PrivateKey = hex.encode(x25519Sk);

    final conversationKey = await Ed25519KeyStore.getX25519SharedSecret(
      publicKey: x25519PublicKey,
      privateKey: x25519PrivateKey,
    );

    final decryptedMessage = await Nip44.decryptMessage(
      message,
      x25519PrivateKey,
      x25519PublicKey,
      customConversationKey: conversationKey,
    );

    return decryptedMessage;
  }
}
