// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/nostr/ed25519_key_store.dart';
import 'package:ion/app/services/storage/secure_storage.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_event_signer_provider.c.g.dart';

@Riverpod(keepAlive: true)
class NostrEventSigner extends _$NostrEventSigner {
  @override
  Future<EventSigner?> build(String identityKeyName) async {
    final storage = ref.watch(secureStorageProvider);
    final storedKey = await storage.getString(key: _storageKey);
    if (storedKey != null) {
      return Ed25519KeyStore.fromPrivate(storedKey);
    }
    return null;
  }

  Future<EventSigner> generate() async {
    final keyStore = await Ed25519KeyStore.generate();
    final storage = ref.read(secureStorageProvider);
    await storage.setString(key: _storageKey, value: keyStore.privateKey);
    state = AsyncData(keyStore);
    return keyStore;
  }

  Future<void> delete() async {
    await ref.read(secureStorageProvider).remove(key: _storageKey);
  }

  String get _storageKey => '${identityKeyName}_nostr_key_store';
}

@Riverpod(keepAlive: true)
Future<EventSigner?> currentUserNostrEventSigner(Ref ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return null;
  }
  return ref.watch(nostrEventSignerProvider(currentIdentityKeyName).future);
}
