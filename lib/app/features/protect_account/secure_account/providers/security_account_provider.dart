// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart' as ion_exceptions;
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/security_methods.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.dart';
import 'package:ion/app/utils/predicates.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_account_provider.g.dart';

@Riverpod(keepAlive: true)
class SecurityAccountController extends _$SecurityAccountController {
  @override
  Future<SecurityMethods> build() async {
    final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
    if (currentUser == null) {
      throw const ion_exceptions.UnauthenticatedException();
    }

    final ionIdentity = await ref.watch(ionIdentityProvider.future);
    final userDetails = await ionIdentity(username: currentUser).users.currentUserDetails();

    final twoFaOptions = userDetails.twoFaOptions ?? [];

    return SecurityMethods(
      isEmailEnabled: twoFaOptions.any(Predicates.startsWith(const TwoFAType.email().option)),
      isPhoneEnabled: twoFaOptions.any(Predicates.startsWith(const TwoFAType.sms().option)),
      isAuthenticatorEnabled:
          twoFaOptions.any(Predicates.startsWith(const TwoFAType.authenticator().option)),
    );
  }

  void toggleBackup({required bool value}) => state = AsyncValue.data(
        state.valueOrNull!.copyWith(isBackupEnabled: value),
      );
}
