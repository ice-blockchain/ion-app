// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';

part 'story.c.freezed.dart';

@freezed
class UserStories with _$UserStories {
  const factory UserStories({
    required String pubkey,
    required List<ModifiablePostEntity> stories,
  }) = _UserStories;

  const UserStories._();

  bool get hasStories => stories.isNotEmpty;

  ModifiablePostEntity? getStoryById(String id) =>
      stories.firstWhereOrNull((post) => post.id == id);

  int getStoryIndex(String id) => stories.indexWhere((post) => post.id == id);

  int getStoryIndexByReference(EventReference eventReference) =>
      stories.indexWhere((post) => post.toEventReference() == eventReference);

  bool hasStoryWithId(String id) => stories.any((post) => post.id == id);
}
