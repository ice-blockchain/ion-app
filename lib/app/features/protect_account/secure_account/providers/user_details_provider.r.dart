// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_details_provider.r.g.dart';

@Riverpod(keepAlive: true)
Future<UserDetails> userDetails(Ref ref) async {
  final ionIdentity = await ref.watch(ionIdentityClientProvider.future);
  return ionIdentity.users.currentUserDetails();
}
