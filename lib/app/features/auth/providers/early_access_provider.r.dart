// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_identity/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'early_access_provider.r.g.dart';

@riverpod
class EarlyAccessNotifier extends _$EarlyAccessNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> verifyEmail({required String email}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      await ionIdentity(username: '').auth.verifyEmailEarlyAccess(
            email: email,
          );
    });
  }
}

@Riverpod(keepAlive: true)
class EarlyAccessEmail extends _$EarlyAccessEmail {
  @override
  String? build() {
    return null;
  }

  Future<void> update(String newEmail) async {
    state = newEmail;
  }
}
