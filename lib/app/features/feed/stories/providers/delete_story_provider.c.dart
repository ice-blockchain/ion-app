// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/delete_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_story_provider.c.g.dart';

@riverpod
Future<bool> deleteStory(
  Ref ref,
  EventReference eventReference,
) async {
  try {
    await deleteEntity(ref, eventReference);
    return true;
  } catch (e, stackTrace) {
    Logger.error(
      'Failed to delete story',
      stackTrace: stackTrace,
    );
    return false;
  }
}
