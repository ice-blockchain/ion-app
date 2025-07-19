// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_model.dart';

part 'post_repost.f.freezed.dart';

@freezed
class PostRepost with _$PostRepost implements OptimisticModel {
  const factory PostRepost({
    required EventReference eventReference,
    required int repostsCount,
    required int quotesCount,
    required bool repostedByMe,
    EventReference? myRepostReference,
  }) = _PostRepost;

  const PostRepost._();

  @override
  String get optimisticId => eventReference.toString();
  int get totalRepostsCount => repostsCount + quotesCount;
}
