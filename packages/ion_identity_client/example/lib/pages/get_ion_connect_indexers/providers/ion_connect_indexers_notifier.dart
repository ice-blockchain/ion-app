// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client_example/providers/current_username_notifier.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_indexers_notifier.g.dart';

@riverpod
class IONConnectIndexersNotifier extends _$IONConnectIndexersNotifier {
  @override
  FutureOr<List<String>?> build() async {
    return null;
  }

  Future<void> fetchIONConnectIndexers(String userId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentUser = ref.watch(currentUsernameNotifierProvider);
      if (currentUser == null) {
        throw Exception('Current user not found');
      }

      final ionIdentity = await ref.watch(ionIdentityProvider.future);
      return await ionIdentity(username: currentUser).users.ionConnectIndexers(
            userId: userId,
          );
    });
  }
}
