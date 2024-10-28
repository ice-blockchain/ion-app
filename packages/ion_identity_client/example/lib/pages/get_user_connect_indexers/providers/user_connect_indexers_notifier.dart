// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/current_username_notifier.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_connect_indexers_notifier.g.dart';

@riverpod
class UserConnectIndexersNotifier extends _$UserConnectIndexersNotifier {
  @override
  FutureOr<List<String>?> build() async {
    return null;
  }

  Future<void> fetchUserConnectIndexers(String userId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentUser = ref.watch(currentUsernameNotifierProvider);
      if (currentUser == null) {
        throw Exception('Current user not found');
      }

      final ionClient = await ref.watch(ionClientProvider.future);
      return await ionClient(username: currentUser).users.getUserConnectIndexers(
            userId: userId,
          );
    });
  }
}
