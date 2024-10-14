// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ice/app/features/user/providers/user_delegation_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
Future<bool?> onboardingComplete(OnboardingCompleteRef ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

  if (currentIdentityKeyName == null) {
    return null;
  }

  final (identity, delegate) = await (
    ref.watch(currentUserIdentityProvider.future),
    ref.watch(currentUserDelegationProvider.future)
  ).wait;

  return delegate != null &&
      identity != null &&
      identity.masterPubkey != null &&
      identity.ionConnectRelays.isNotEmpty;
}
