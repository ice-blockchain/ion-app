// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_identity_client_provider.g.dart';

@riverpod
Future<Raw<IONIdentityClient>> ionIdentityClient(Ref ref) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw Exception('Current user not found');
  }

  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  return ionIdentity(username: currentUser);
}
