// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/groups/model/create_group_form_data.dart';
import 'package:ion/app/features/chat/groups/model/group_type.dart';
import 'package:ion/app/features/chat/groups/model/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_group_form_controller_provider.g.dart';

@riverpod
class CreateGroupFormController extends _$CreateGroupFormController {
  @override
  CreateGroupFormData build() => const CreateGroupFormData();

  set type(GroupType value) => state = state.copyWith(type: value);

  set title(String value) => state = state.copyWith(title: value);

  set members(Iterable<User> value) => state = state.copyWith(members: value.toSet());

  set coverUrl(String value) => state = state.copyWith(coverUrl: value);

  void toggleMember(User member) {
    final newSelected = state.members.toSet();
    newSelected.contains(member) ? newSelected.remove(member) : newSelected.add(member);

    state = state.copyWith(members: newSelected);
  }
}
