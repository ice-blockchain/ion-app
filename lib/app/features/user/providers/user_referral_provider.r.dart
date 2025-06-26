// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_referral_provider.r.g.dart';

@riverpod
class UserReferralNotifier extends _$UserReferralNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> verifyReferralExists({required String referral}) async {
    state = const AsyncValue.loading();
    try {
      final ionIdentityClient = await ref.watch(ionIdentityClientProvider.future);
      await ionIdentityClient.users.verifyNicknameAvailability(
        nickname: referral,
      );
      // If no exception was thrown, the nickname is available (referral does not exist)
      throw NicknameDoesntExistException(referral);
    } on NicknameAlreadyExistsException {
      // Nickname already exists: referral exists
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}
