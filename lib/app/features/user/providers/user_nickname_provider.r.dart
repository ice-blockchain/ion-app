// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_nickname_provider.r.g.dart';

@riverpod
class UserNicknameNotifier extends _$UserNicknameNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> verifyNicknameAvailability({required String nickname}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentityClient = await ref.watch(ionIdentityClientProvider.future);
      await ionIdentityClient.users.verifyNicknameAvailability(
        nickname: nickname,
      );
    });
  }
}
