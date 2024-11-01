// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/current_username_notifier.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_ion_connect_relays_notifier.g.dart';

@riverpod
class SetIonConnectRelaysNotifier extends _$SetIonConnectRelaysNotifier {
  @override
  FutureOr<SetIonConnectRelaysResponse?> build() async {
    return null;
  }

  Future<void> setIonConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentUser = ref.watch(currentUsernameNotifierProvider);
      if (currentUser == null) {
        throw Exception('Current user not found');
      }

      final ionIdentity = await ref.watch(ionClientProvider.future);
      return await ionIdentity(username: currentUser).users.setIonConnectRelays(
            userId: userId,
            followeeList: followeeList,
          );
    });
  }
}
