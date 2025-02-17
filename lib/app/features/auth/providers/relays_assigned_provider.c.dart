// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_assigned_provider.c.g.dart';

@riverpod
Future<bool?> relaysAssigned(Ref ref) async {
  final identity = await ref.watch(currentUserIdentityProvider.future);

  return identity != null && (identity.ionConnectRelays?.isNotEmpty).falseOrValue;
}
