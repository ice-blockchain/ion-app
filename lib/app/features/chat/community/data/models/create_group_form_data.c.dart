// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/community/data/models/group_type.dart';

part 'create_group_form_data.c.freezed.dart';

@freezed
class CreateGroupFormData with _$CreateGroupFormData {
  const factory CreateGroupFormData({
    String? name,
    @Default(GroupType.public) GroupType type,
    @Default({}) Set<String> participantsMasterkeys,
  }) = _CreateGroupFormData;

  const CreateGroupFormData._();

  bool get canCreate => name != null && name!.isNotEmpty;
}
