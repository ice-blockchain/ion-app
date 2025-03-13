// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/providers/delete_entity_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_story_provider.c.g.dart';

@riverpod
class DeleteStoryController extends _$DeleteStoryController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> deleteStory(EventReference eventReference) async {
    state = const AsyncValue.loading();

    try {
      await ref.read(deleteEntityProvider(eventReference).future);
      ref.invalidate(storiesProvider);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to delete story',
        stackTrace: stackTrace,
      );
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}
