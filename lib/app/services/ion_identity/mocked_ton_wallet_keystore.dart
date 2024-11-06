// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/storage/local_storage.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mocked_ton_wallet_keystore.g.dart';

@riverpod
Future<KeyStore> mockedMainWallet(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final mainWalletPrivateKey = prefs.getString('main-wallet');
  if (mainWalletPrivateKey != null) {
    return KeyStore.fromPrivate(mainWalletPrivateKey);
  }
  final keyStore = KeyStore.generate();
  await prefs.setString('main-wallet', keyStore.privateKey);
  return keyStore;
}
