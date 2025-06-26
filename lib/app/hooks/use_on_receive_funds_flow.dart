// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/security_account_provider.r.dart';
import 'package:ion/app/features/user/providers/user_verify_identity_provider.r.dart';

void Function() useOnReceiveFundsFlow({
  required void Function() onReceive,
  required void Function() onNeedToEnable2FA,
  required WidgetRef ref,
}) {
  final is2FAEnabledForCurrentUser = ref.watch(is2FAEnabledForCurrentUserProvider).value ?? false;
  final isPasswordFlowUser = ref.watch(isPasswordFlowUserProvider).value ?? false;
  return () {
    if (isPasswordFlowUser && !is2FAEnabledForCurrentUser) {
      onNeedToEnable2FA();
    } else {
      onReceive();
    }
  };
}
