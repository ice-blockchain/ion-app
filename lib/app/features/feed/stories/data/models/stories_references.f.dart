// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

part 'stories_references.f.freezed.dart';

@freezed
class StoriesReferences with _$StoriesReferences {
  const factory StoriesReferences(
    Iterable<EventReference> references,
  ) = _StoriesReferences;
}
