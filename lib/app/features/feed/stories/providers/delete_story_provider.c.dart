import 'package:ion/app/features/feed/providers/delete_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_story_provider.c.g.dart';

@riverpod
class DeleteStoryController extends _$DeleteStoryController {
  @override
  FutureOr<void> build() {}

  Future<bool> deleteStory(EventReference eventReference) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await deleteEntity(ref, eventReference);
    });

    return state.hasError == false;
  }
}
