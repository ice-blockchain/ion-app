// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/community/data/models/community_admin_type.dart';
import 'package:ion/app/features/chat/community/data/models/entities/community_definition_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_admins_provider.c.g.dart';

@riverpod
class CommunityAdmins extends _$CommunityAdmins {
  @override
  Map<String, CommunityAdminType> build() {
    return {};
  }

  void init(CommunityDefinitionEntity community) {
    final admins = community.data.admins.map((e) => MapEntry(e, CommunityAdminType.admin)).toList();
    final moderators =
        community.data.moderators.map((e) => MapEntry(e, CommunityAdminType.moderator)).toList();
    final owner = MapEntry(community.ownerPubkey, CommunityAdminType.owner);
    state = Map<String, CommunityAdminType>.unmodifiable(
      Map.fromEntries([...admins, ...moderators, owner]),
    );
  }

  void setAdmin(String pubkey, CommunityAdminType type) {
    final newState = Map<String, CommunityAdminType>.from(state);
    newState[pubkey] = type;
    state = Map<String, CommunityAdminType>.unmodifiable(newState);
  }

  void deleteAdmin(String pubkey) {
    state = Map<String, CommunityAdminType>.unmodifiable(
      Map<String, CommunityAdminType>.from(state)..remove(pubkey),
    );
  }
}
