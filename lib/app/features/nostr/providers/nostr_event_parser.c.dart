// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/nostr/model/file_metadata.c.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/model/interests.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_event_parser.c.g.dart';

class EventParser {
  NostrEntity parse(EventMessage eventMessage) {
    return switch (eventMessage.kind) {
      UserMetadataEntity.kind => UserMetadataEntity.fromEventMessage(eventMessage),
      PostEntity.kind => PostEntity.fromEventMessage(eventMessage),
      ArticleEntity.kind => ArticleEntity.fromEventMessage(eventMessage),
      UserRelaysEntity.kind => UserRelaysEntity.fromEventMessage(eventMessage),
      FollowListEntity.kind => FollowListEntity.fromEventMessage(eventMessage),
      InterestSetEntity.kind => InterestSetEntity.fromEventMessage(eventMessage),
      InterestsEntity.kind => InterestsEntity.fromEventMessage(eventMessage),
      UserDelegationEntity.kind => UserDelegationEntity.fromEventMessage(eventMessage),
      RepostEntity.kind => RepostEntity.fromEventMessage(eventMessage),
      GenericRepostEntity.kind => GenericRepostEntity.fromEventMessage(eventMessage),
      FileMetadataEntity.kind => FileMetadataEntity.fromEventMessage(eventMessage),
      ReactionEntity.kind => ReactionEntity.fromEventMessage(eventMessage),
      _ => throw UnknownEventException(eventId: eventMessage.id, kind: eventMessage.kind)
    } as NostrEntity;
  }
}

@riverpod
EventParser eventParser(Ref ref) => EventParser();
