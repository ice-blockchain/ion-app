// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recovery_key_data_provider.g.dart';

@riverpod
Future<CreateRecoveryCredentialsSuccess> recoveryKeyData(RecoveryKeyDataRef ref) async {
  final selectedUser = ref.watch(authProvider).valueOrNull?.selectedIdentityKeyName;
  if (selectedUser == null) {
    throw Exception('No selected user');
  }

  final ionClient = await ref.watch(ionApiClientProvider.future);

  final result = await ionClient(username: selectedUser).auth.createRecoveryCredentials();

  return switch (result) {
    CreateRecoveryCredentialsSuccess() => result,
    _ => throw Exception('Error creating recovery credentials'),
  };
}
