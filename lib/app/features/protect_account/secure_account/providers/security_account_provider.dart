// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/protect_account/secure_account/data/models/security_methods.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/user_details_provider.dart';
import 'package:ion/app/utils/predicates.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_account_provider.g.dart';

@Riverpod(keepAlive: true)
class SecurityAccountController extends _$SecurityAccountController {
  @override
  Future<SecurityMethods> build() async {
    final userDetails = await ref.watch(userDetailsProvider.future);
    final twoFaOptions = userDetails.twoFaOptions ?? [];

    return SecurityMethods(
      isEmailEnabled: twoFaOptions.any(startsWith(const TwoFAType.email().option)),
      isPhoneEnabled: twoFaOptions.any(startsWith(const TwoFAType.sms().option)),
      isAuthenticatorEnabled: twoFaOptions.any(startsWith(const TwoFAType.authenticator().option)),
    );
  }

  void toggleBackup({required bool value}) => state = AsyncValue.data(
        state.valueOrNull!.copyWith(isBackupEnabled: value),
      );
}
