// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_wallets_provider.r.g.dart';

@riverpod
Future<List<Wallet>> userWallets(Ref ref, String username) async {
  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  return ionIdentity(username: username).wallets.getWallets();
}
