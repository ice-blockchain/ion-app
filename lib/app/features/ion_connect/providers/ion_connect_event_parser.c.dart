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
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/polls/models/poll_vote.c.dart';
import 'package:ion/app/features/ion_connect/data/models/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/data/models/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/data/models/mute_set.c.dart';
import 'package:ion/app/features/ion_connect/data/models/not_authoritative_event.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription.c.dart';
import 'package:ion/app/features/user/data/models/badges/badge_award.c.dart';
import 'package:ion/app/features/user/data/models/badges/badge_definition.c.dart';
import 'package:ion/app/features/user/data/models/badges/profile_badges.c.dart';
import 'package:ion/app/features/user/data/models/block_list.c.dart';
import 'package:ion/app/features/user/data/models/follow_list.c.dart';
import 'package:ion/app/features/user/data/models/interest_set.c.dart';
import 'package:ion/app/features/user/data/models/interests.c.dart';
import 'package:ion/app/features/user/data/models/user_chat_relays.c.dart';
import 'package:ion/app/features/user/data/models/user_delegation.c.dart';
import 'package:ion/app/features/user/data/models/user_metadata.c.dart';
import 'package:ion/app/features/user/data/models/user_relays.c.dart';
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
      MuteSetEntity.kind => MuteSetEntity.fromEventMessage(eventMessage),
      PushSubscriptionEntity.kind => PushSubscriptionEntity.fromEventMessage(eventMessage),
      DeletionRequestEntity.kind => DeletionRequestEntity.fromEventMessage(eventMessage),
      IonConnectGiftWrapEntity.kind => IonConnectGiftWrapEntity.fromEventMessage(eventMessage),
      BadgeDefinitionEntity.kind => BadgeDefinitionEntity.fromEventMessage(eventMessage),
      ProfileBadgesEntity.kind => ProfileBadgesEntity.fromEventMessage(eventMessage),
      BadgeAwardEntity.kind => BadgeAwardEntity.fromEventMessage(eventMessage),
      PollVoteEntity.kind => PollVoteEntity.fromEventMessage(eventMessage),
      _ => throw UnknownEventException(eventId: eventMessage.id, kind: eventMessage.kind)
    };
  }
}

@riverpod
EventParser eventParser(Ref ref) => EventParser();
