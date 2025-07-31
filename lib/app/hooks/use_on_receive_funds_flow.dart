// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.r.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.r.dart';
import 'package:ion/app/features/user/providers/user_verify_identity_provider.r.dart';

void Function() useOnReceiveFundsFlow({
  required void Function() onReceive,
  required void Function() onNeedToEnable2FA,
  required WidgetRef ref,
}) {
  final is2FAEnabledForCurrentUser = ref.watch(is2FAEnabledForCurrentUserProvider).value ?? false;
  final isBackupEnabledForCurrentUser =
      ref.watch(isBackupEnabledForCurrentUserProvider).value ?? false;
  final isAccountSecured = is2FAEnabledForCurrentUser && isBackupEnabledForCurrentUser;

  final isPasswordFlowUser = ref.watch(isPasswordFlowUserProvider).value ?? false;
  final forceSecurityEnabled =
      ref.watch(featureFlagsProvider.notifier).get(WalletFeatureFlag.forceSecurityEnabled);
  return () {
    if ((isPasswordFlowUser || forceSecurityEnabled) && !isAccountSecured) {
      onNeedToEnable2FA();
    } else {
      onReceive();
    }
  };
}
