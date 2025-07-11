// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';

part 'user_story.f.freezed.dart';

@freezed
class UserStory with _$UserStory {
  const factory UserStory({
    required String pubkey,
    required ModifiablePostEntity story,
  }) = _UserStory;

  const UserStory._();
}
