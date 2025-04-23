// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/optimistic_ui/optimistic_model.dart';

class PostLike implements OptimisticModel {
  const PostLike({
    required this.eventReference,
    required this.likesCount,
    required this.likedByMe,
  });

  final EventReference eventReference;
  final int likesCount;
  final bool likedByMe;

  PostLike copyWith({
    EventReference? eventReference,
    int? likesCount,
    bool? likedByMe,
  }) =>
      PostLike(
        eventReference: eventReference ?? this.eventReference,
        likesCount: likesCount ?? this.likesCount,
        likedByMe: likedByMe ?? this.likedByMe,
      );

  @override
  String get optimisticId => eventReference.toString();

  @override
  bool equals(Object other) {
    return other is PostLike &&
        other.optimisticId == optimisticId &&
        other.likesCount == likesCount &&
        other.likedByMe == likedByMe;
  }

  @override
  String toString() =>
      'PostLike(event: $eventReference, likes: $likesCount, likedByMe: $likedByMe)';
}
