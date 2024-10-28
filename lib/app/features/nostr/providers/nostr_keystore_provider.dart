// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_keystore_provider.g.dart';

@Riverpod(keepAlive: true)
class NostrKeyStore extends _$NostrKeyStore {
  @override
  Future<KeyStore?> build(String identityKeyName) async {
    final storage = ref.watch(secureStorageProvider);
    final storedKey = await storage.getString(key: _storageKey);
    if (storedKey != null) {
      return KeyStore.fromPrivate(storedKey);
    }
    return null;
  }

  Future<KeyStore> generate() async {
    final keyStore = KeyStore.generate();
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
Future<KeyStore?> currentUserNostrKeyStore(Ref ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return null;
  }
  return ref.watch(nostrKeyStoreProvider(currentIdentityKeyName).future);
}
