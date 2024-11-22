// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/groups/model/group_type.dart';
import 'package:ion/app/features/groups/model/user.dart';

part 'create_group_form_data.freezed.dart';

@freezed
class CreateGroupFormData with _$CreateGroupFormData {
  const factory CreateGroupFormData({
    @Default(GroupType.public) GroupType type,
    @Default('') String title,
    @Default({}) Set<User> members,
    String? coverUrl,
  }) = _CreateGroupFormData;
}
