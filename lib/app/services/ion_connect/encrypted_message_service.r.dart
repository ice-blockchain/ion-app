// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.r.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:nip44/nip44.dart';
import 'package:pinenacl/tweetnacl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_message_service.r.g.dart';

@riverpod
Future<EncryptedMessageService> encryptedMessageService(Ref ref) async {
  final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

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

  Future<String> encryptMessage(
    String message, {
    String? publicKey,
    String? privateKey,
    CompressionAlgorithm compressionAlgorithm = CompressionAlgorithm.none,
  }) async {
    final x25519PublicKey = _convertEd25519PkToX25519(publicKey ?? currentUserPubkey);
    final x25519PrivateKey = _convertEd25519SkToX25519(privateKey ?? eventSigner.privateKey);

    final conversationKey = await _buildConversationKey(
      x25519PrivateKey: x25519PrivateKey,
      x25519PublicKey: x25519PublicKey,
    );

    return Nip44.encryptMessage(
      message,
      x25519PrivateKey,
      x25519PublicKey,
      customConversationKey: conversationKey,
      compressionAlgorithm: compressionAlgorithm,
    );
  }

  Future<String> decryptMessage(
    String message, {
    String? publicKey,
    String? privateKey,
    CompressionAlgorithm compressionAlgorithm = CompressionAlgorithm.none,
  }) async {
    final x25519PublicKey = _convertEd25519PkToX25519(publicKey ?? currentUserPubkey);
    final x25519PrivateKey = _convertEd25519SkToX25519(privateKey ?? eventSigner.privateKey);

    final conversationKey = await _buildConversationKey(
      x25519PrivateKey: x25519PrivateKey,
      x25519PublicKey: x25519PublicKey,
    );

    return Nip44.decryptMessage(
      message,
      x25519PrivateKey,
      x25519PublicKey,
      customConversationKey: conversationKey,
      compressionAlgorithm: compressionAlgorithm,
    );
  }

  String _convertEd25519PkToX25519(String publicKey) {
    final x25519Pk = Uint8List.fromList(List.filled(32, 0));
    final ed25519Pk = Uint8List.fromList(hex.decode(publicKey));
    TweetNaClExt.crypto_sign_ed25519_pk_to_x25519_pk(x25519Pk, ed25519Pk);
    return hex.encode(x25519Pk);
  }

  String _convertEd25519SkToX25519(String privateKey) {
    final x25519Sk = Uint8List.fromList(List.filled(32, 0));
    final ed25519Sk = Uint8List.fromList(hex.decode(privateKey));
    TweetNaClExt.crypto_sign_ed25519_sk_to_x25519_sk(x25519Sk, ed25519Sk);
    return hex.encode(x25519Sk);
  }

  Future<Uint8List> _buildConversationKey({
    required String x25519PublicKey,
    required String x25519PrivateKey,
  }) async {
    final sharedSecret = await Ed25519KeyStore.getX25519SharedSecret(
      privateKey: x25519PrivateKey,
      publicKey: x25519PublicKey,
    );

    return Nip44.deriveConversationKey(sharedSecret);
  }
}
