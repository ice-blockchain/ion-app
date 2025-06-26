// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_transfer_requests_provider.r.g.dart';

@riverpod
Future<WalletTransferRequests> walletTransferRequests(
  Ref ref,
  String walletId, {
  String? pageToken,
}) async {
  final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';

  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  return ionIdentity(username: username).wallets.getWalletTransferRequests(
        walletId,
        pageToken: pageToken,
      );
}
