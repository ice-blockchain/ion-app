// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_model.dart';

part 'post_like.c.freezed.dart';

@freezed
class PostLike with _$PostLike implements OptimisticModel {
  const factory PostLike({
    required EventReference eventReference,
    required int likesCount,
    required bool likedByMe,
  }) = _PostLike;
  const PostLike._();

  @override
  String get optimisticId => eventReference.toString();
}
