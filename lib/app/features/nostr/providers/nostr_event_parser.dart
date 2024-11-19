// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/article_data.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/data/models/repost_data.dart';
import 'package:ion/app/features/nostr/model/file_metadata.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/user/model/follow_list.dart';
import 'package:ion/app/features/user/model/interest_set.dart';
import 'package:ion/app/features/user/model/interests.dart';
import 'package:ion/app/features/user/model/user_delegation.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_event_parser.g.dart';

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
      _ => throw UnknownEventException(eventId: eventMessage.id, kind: eventMessage.kind)
    } as NostrEntity;
  }
}

@riverpod
EventParser eventParser(Ref ref) => EventParser();
