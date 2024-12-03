// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/model/group.dart';
import 'package:ion/app/features/chat/providers/create_group_form_controller_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_chat_group_provider.g.dart';

@riverpod
Group createChatGroup(Ref ref) {
  final createGroupForm = ref.read(createGroupFormControllerProvider);

  return Group(
    id: 'new_group',
    link: 'https://ice.io/testers_group',
    name: createGroupForm.name!,
    type: createGroupForm.type,
    members: createGroupForm.members.toList(),
    imageUrl: 'https://picsum.photos/200/300',
    // TODO: To get group image and send to the server use the next commented code
    // image: ref.read(avatarProcessorNotifierProvider).mapOrNull(
    //   cropped: (file) => file.file,
    //   processed: (file) => file.file,
    // ),
  );
}
