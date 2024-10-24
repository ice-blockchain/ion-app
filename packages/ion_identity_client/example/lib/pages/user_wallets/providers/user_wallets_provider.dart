// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_wallets_provider.g.dart';

@riverpod
Future<List<Wallet>> userWallets(Ref ref, String username) async {
  final ionClient = await ref.watch(ionClientProvider.future);
  return ionClient(username: username).wallets.getWallets();
}
