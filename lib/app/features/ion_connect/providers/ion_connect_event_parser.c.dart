// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_update_data.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/not_authoritative_event.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/model/interests.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_event_parser.c.g.dart';

class EventParser {
  IonConnectEntity parse(EventMessage eventMessage) {
    return switch (eventMessage.kind) {
      UserMetadataEntity.kind => UserMetadataEntity.fromEventMessage(eventMessage),
      ArticleEntity.kind => ArticleEntity.fromEventMessage(eventMessage),
      UserRelaysEntity.kind => UserRelaysEntity.fromEventMessage(eventMessage),
      UserChatRelaysEntity.kind => UserChatRelaysEntity.fromEventMessage(eventMessage),
      FollowListEntity.kind => FollowListEntity.fromEventMessage(eventMessage),
      InterestSetEntity.kind => InterestSetEntity.fromEventMessage(eventMessage),
      InterestsEntity.kind => InterestsEntity.fromEventMessage(eventMessage),
      UserDelegationEntity.kind => UserDelegationEntity.fromEventMessage(eventMessage),
      GenericRepostEntity.kind => GenericRepostEntity.fromEventMessage(eventMessage),
      RepostEntity.kind => RepostEntity.fromEventMessage(eventMessage),
      FileMetadataEntity.kind => FileMetadataEntity.fromEventMessage(eventMessage),
      ReactionEntity.kind => ReactionEntity.fromEventMessage(eventMessage),
      EventCountResultEntity.kind => EventCountResultEntity.fromEventMessage(eventMessage),
      BookmarksSetEntity.kind => BookmarksSetEntity.fromEventMessage(eventMessage),
      BookmarksEntity.kind => BookmarksEntity.fromEventMessage(eventMessage),
      BlockListEntity.kind => BlockListEntity.fromEventMessage(eventMessage),
      NotAuthoritativeEvent.kind => NotAuthoritativeEvent.fromEventMessage(eventMessage),
      ModifiablePostEntity.kind => ModifiablePostEntity.fromEventMessage(eventMessage),
      PostEntity.kind => PostEntity.fromEventMessage(eventMessage),
      CommunityDefinitionEntity.kind => CommunityDefinitionEntity.fromEventMessage(eventMessage),
      CommunityUpdateEntity.kind => CommunityUpdateEntity.fromEventMessage(eventMessage),
      CommunityJoinEntity.kind => CommunityJoinEntity.fromEventMessage(eventMessage),
      WalletAssetEntity.kind => WalletAssetEntity.fromEventMessage(eventMessage),
      _ => throw UnknownEventException(eventId: eventMessage.id, kind: eventMessage.kind)
    };
  }
}

@riverpod
EventParser eventParser(Ref ref) => EventParser();
