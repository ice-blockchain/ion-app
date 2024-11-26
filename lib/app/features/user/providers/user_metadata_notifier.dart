// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_notifier.g.dart';

@riverpod
class UserMetadataNotifier extends _$UserMetadataNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> send(UserMetadata userMetadata) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ref.read(nostrNotifierProvider.notifier).sendEntityData(userMetadata);
    });
  }
}
