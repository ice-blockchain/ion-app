// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/providers/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/services/providers/storage/secure_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_event_signer_provider.c.g.dart';

@Riverpod(keepAlive: true)
class IonConnectEventSigner extends _$IonConnectEventSigner {
  @override
  Future<EventSigner?> build(String identityKeyName) async {
    final storage = ref.watch(secureStorageProvider);
    final storedKey = await storage.getString(key: _storageKey);
    if (storedKey != null) {
      return Ed25519KeyStore.fromPrivate(storedKey);
    }
    return null;
  }

  Future<void> delete() async {
    await ref.read(secureStorageProvider).remove(key: _storageKey);
  }

  Future<EventSigner?> initEventSigner() async {
    final currentUserIonConnectEventSigner =
        await ref.read(ionConnectEventSignerProvider(identityKeyName).future);
    if (currentUserIonConnectEventSigner != null) {
      // Event signer already exists, reuse it
      return currentUserIonConnectEventSigner;
    }

    // Generate a new event signer
    return _generate();
  }

  /// Restores an event signer from a private key string
  /// This is used for device keypair restoration from uploaded
  Future<EventSigner> restoreFromPrivateKey(String privateKey) async {
    final keyStore = await Ed25519KeyStore.fromPrivate(privateKey);
    return _setEventSigner(keyStore);
  }

  Future<EventSigner> _generate() async {
    final keyStore = await Ed25519KeyStore.generate();
    return _setEventSigner(keyStore);
  }

  Future<EventSigner> _setEventSigner(EventSigner signer) async {
    final storage = ref.read(secureStorageProvider);
    await storage.setString(key: _storageKey, value: signer.privateKey);
    state = AsyncData(signer);
    return signer;
  }

  // TODO: Introduce and migrate into ionConnect key store
  String get _storageKey => '${identityKeyName}_nostr_key_store';
}

@Riverpod(keepAlive: true)
Future<EventSigner?> currentUserIonConnectEventSigner(Ref ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return null;
  }
  return ref.watch(ionConnectEventSignerProvider(currentIdentityKeyName).future);
}
