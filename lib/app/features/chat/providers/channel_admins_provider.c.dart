// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_admins_provider.c.g.dart';

@riverpod
class ChannelAdmins extends _$ChannelAdmins {
  @override
  Map<String, ChannelAdminType> build() {
    return {};
  }

  void init(CommunityDefinitionEntity community) {
    final admins = community.data.admins.map((e) => MapEntry(e, ChannelAdminType.admin)).toList();
    final moderators =
        community.data.moderators.map((e) => MapEntry(e, ChannelAdminType.moderator)).toList();
    final owner = MapEntry(community.ownerPubkey, ChannelAdminType.owner);
    state = Map<String, ChannelAdminType>.unmodifiable(
      Map.fromEntries([...admins, ...moderators, owner]),
    );
  }

  void setAdmin(String pubkey, ChannelAdminType type) {
    final newState = Map<String, ChannelAdminType>.from(state);
    newState[pubkey] = type;
    state = Map<String, ChannelAdminType>.unmodifiable(newState);
  }

  void deleteAdmin(String pubkey) {
    state = Map<String, ChannelAdminType>.unmodifiable(
      Map<String, ChannelAdminType>.from(state)..remove(pubkey),
    );
  }
}
