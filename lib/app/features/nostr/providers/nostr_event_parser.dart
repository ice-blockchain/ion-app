// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
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
      UserMetadataEntity.kind => UserMetadata.fromEventMessage(eventMessage),
      PostEntity.kind => PostData.fromEventMessage(eventMessage),
      UserRelaysEntity.kind => UserRelaysEntity.fromEventMessage(eventMessage),
      FollowListEntity.kind => FollowListEntity.fromEventMessage(eventMessage),
      InterestSetEntity.kind => InterestSetEntity.fromEventMessage(eventMessage),
      InterestsEntity.kind => InterestsEntity.fromEventMessage(eventMessage),
      UserDelegationEntity.kind => UserDelegationEntity.fromEventMessage(eventMessage),
      _ => throw Exception('Unknown event with kind->${eventMessage.kind}')
    } as NostrEntity;
  }
}

@riverpod
EventParser eventParser(Ref ref) => EventParser();
