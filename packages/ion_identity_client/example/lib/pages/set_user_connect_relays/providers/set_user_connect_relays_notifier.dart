// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/current_username_notifier.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_user_connect_relays_notifier.g.dart';

@riverpod
class SetUserConnectRelaysNotifier extends _$SetUserConnectRelaysNotifier {
  @override
  FutureOr<SetUserConnectRelaysResponse?> build() async {
    return null;
  }

  Future<void> setUserConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentUser = ref.watch(currentUsernameNotifierProvider);
      if (currentUser == null) {
        throw Exception('Current user not found');
      }

      final ionClient = await ref.watch(ionClientProvider.future);
      return await ionClient(username: currentUser).users.setUserConnectRelays(
            userId: userId,
            followeeList: followeeList,
          );
    });
  }
}
