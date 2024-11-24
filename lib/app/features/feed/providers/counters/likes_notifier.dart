// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_notifier.g.dart';

@Riverpod(dependencies: [nostrEntity])
class LikesNotifier extends _$LikesNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> like({
    required EventReference eventReference,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
    });
  }
}
