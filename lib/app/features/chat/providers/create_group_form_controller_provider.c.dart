// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/create_group_form_data.c.dart';
import 'package:ion/app/features/chat/model/group_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_group_form_controller_provider.c.g.dart';

@riverpod
class CreateGroupFormController extends _$CreateGroupFormController {
  @override
  CreateGroupFormData build() => const CreateGroupFormData();

  set type(GroupType value) => state = state.copyWith(type: value);

  set title(String value) => state = state.copyWith(name: value);

  set members(Iterable<String> value) => state = state.copyWith(members: value.toSet());

  void toggleMember(String pubkey) {
    final updatedMembers = state.members.toSet();
    updatedMembers.contains(pubkey) ? updatedMembers.remove(pubkey) : updatedMembers.add(pubkey);

    state = state.copyWith(members: updatedMembers);
  }
}
