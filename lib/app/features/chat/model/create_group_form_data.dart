// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/group_type.dart';

part 'create_group_form_data.freezed.dart';

@freezed
class CreateGroupFormData with _$CreateGroupFormData {
  const factory CreateGroupFormData({
    @Default(GroupType.public) GroupType type,
    String? title,
    @Default({}) Set<String> members,
  }) = _CreateGroupFormData;

  const CreateGroupFormData._();

  bool get canCreate => title != null && title!.isNotEmpty;
}
