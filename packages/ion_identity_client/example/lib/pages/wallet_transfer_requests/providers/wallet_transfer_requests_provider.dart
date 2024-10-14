// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/current_username_notifier.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_transfer_requests_provider.g.dart';

@riverpod
Future<WalletTransferRequests> walletTransferRequests(
  WalletTransferRequestsRef ref,
  String walletId, {
  String? pageToken,
}) async {
  final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';
  final ionClient = await ref.watch(ionClientProvider.future);

  return ionClient(username: username).wallets.getWalletTransferRequests(
        walletId,
        pageToken: pageToken,
      );
}
