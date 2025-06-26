// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_ion_connect_relays_notifier.r.g.dart';

@riverpod
class SetIONConnectRelaysNotifier extends _$SetIONConnectRelaysNotifier {
  @override
  FutureOr<SetIONConnectRelaysResponse?> build() async {
    return null;
  }

  Future<void> setIONConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentUser = ref.watch(currentUsernameNotifierProvider);
      if (currentUser == null) {
        throw Exception('Current user not found');
      }

      final ionIdentity = await ref.watch(ionIdentityProvider.future);
      return await ionIdentity(username: currentUser).users.setIONConnectRelays(
            followeeList: followeeList,
          );
    });
  }
}
