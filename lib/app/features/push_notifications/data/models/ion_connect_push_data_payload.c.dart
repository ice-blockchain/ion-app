// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';

part 'ion_connect_push_data_payload.c.freezed.dart';
part 'ion_connect_push_data_payload.c.g.dart';

@Freezed(toJson: false)
class IonConnectPushDataPayload with _$IonConnectPushDataPayload {
  const factory IonConnectPushDataPayload({
    @JsonKey(fromJson: _entityFromEventJson) required EventMessage event,
    @Default([])
    @JsonKey(name: 'relevant_events', fromJson: _entityListFromEventListJson)
    List<EventMessage> relevantEvents,
  }) = _IonConnectPushDataPayload;

  factory IonConnectPushDataPayload.fromJson(Map<String, dynamic> json) =>
      _$IonConnectPushDataPayloadFromJson(json);

  const IonConnectPushDataPayload._();

  IonConnectEntity get mainEntity {
    return EventParser().parse(event);
  }

  PushNotificationType? getNotificationType({
    required String currentPubkey,
  }) {
    final entity = mainEntity;
    if (entity is GenericRepostEntity ||
        entity is RepostEntity ||
        (entity is ModifiablePostEntity && entity.data.quotedEvent != null) ||
        (entity is PostEntity && entity.data.quotedEvent != null)) {
      return PushNotificationType.repost;
    } else if (entity is ModifiablePostEntity || entity is PostEntity) {
      final currentUserMention =
          ReplaceableEventReference(pubkey: currentPubkey, kind: UserMetadataEntity.kind).encode();
      final content = switch (entity) {
        ModifiablePostEntity() => entity.data.content,
        PostEntity() => entity.data.content,
        _ => null
      };
      if (content?.contains(currentUserMention) ?? false) {
        return PushNotificationType.mention;
      } else {
        return PushNotificationType.reply;
      }
    } else if (entity is ReactionEntity) {
      return PushNotificationType.like;
    } else if (entity is FollowListEntity) {
      return PushNotificationType.follower;
    } else if (entity is IonConnectGiftWrapEntity) {
      if (entity.data.kinds.contains(ReplaceablePrivateDirectMessageEntity.kind.toString())) {
        return PushNotificationType.chatMessage;
      } else if (entity.data.kinds.contains(ReactionEntity.kind.toString())) {
        return PushNotificationType.chatReaction;
      } else if (entity.data.kinds.contains(FundsRequestEntity.kind.toString())) {
        return PushNotificationType.paymentRequest;
      } else if (entity.data.kinds.contains(WalletAssetEntity.kind.toString())) {
        return PushNotificationType.paymentReceived;
      }
    }
    return null;
  }

  Map<String, String> get placeholders {
    final mainEntityUserMetadata = _getUserMetadata(pubkey: mainEntity.masterPubkey);

    if (mainEntityUserMetadata != null) {
      return {'username': mainEntityUserMetadata.data.displayName};
    }

    return {};
  }

  Future<bool> validate({required String currentPubkey}) async {
    return await _checkEventsSignatures() &&
        _checkMainEventRelevant(currentPubkey: currentPubkey) &&
        _checkRequiredRelevantEvents();
  }

  Future<bool> _checkEventsSignatures() async {
    final valid = await Future.wait(
      [
        event.validate(),
        ...relevantEvents.map((event) => event.validate()),
      ],
    );
    return valid.every((valid) => valid);
  }

  bool _checkMainEventRelevant({required String currentPubkey}) {
    final entity = mainEntity;
    if (entity is ModifiablePostEntity || entity is PostEntity) {
      final relatedPubkeys = switch (entity) {
        ModifiablePostEntity() => entity.data.relatedPubkeys,
        PostEntity() => entity.data.relatedPubkeys,
        _ => null
      };
      return relatedPubkeys != null &&
          relatedPubkeys.any((relatedPubkey) => relatedPubkey.value == currentPubkey);
    } else if (entity is GenericRepostEntity) {
      return entity.data.eventReference.pubkey == currentPubkey;
    } else if (entity is RepostEntity) {
      return entity.data.eventReference.pubkey == currentPubkey;
    } else if (entity is ReactionEntity) {
      return entity.data.eventReference.pubkey == currentPubkey;
    } else if (entity is FollowListEntity) {
      return entity.pubkeys.lastOrNull == currentPubkey;
    } else if (entity is IonConnectGiftWrapEntity) {
      return entity.data.relatedPubkeys
          .any((relatedPubkey) => relatedPubkey.value == currentPubkey);
    }
    return false;
  }

  bool _checkRequiredRelevantEvents() {
    if (event.kind == IonConnectGiftWrapEntity.kind) {
      return true;
    } else {
      // For all events except 1059 we need to check if delegation is present
      // in the relevant events and the main event valid for it
      final delegationEvent =
          relevantEvents.firstWhereOrNull((event) => event.kind == UserDelegationEntity.kind);
      if (delegationEvent == null) {
        return false;
      }
      final delegationEntity = EventParser().parse(delegationEvent) as UserDelegationEntity;
      return delegationEntity.data.validate(event);
    }
  }

  UserMetadataEntity? _getUserMetadata({required String pubkey}) {
    final delegationEvent = relevantEvents.firstWhereOrNull((event) {
      return event.kind == UserDelegationEntity.kind && event.pubkey == pubkey;
    });
    if (delegationEvent == null) {
      return null;
    }
    final eventParser = EventParser();
    final delegationEntity = eventParser.parse(delegationEvent) as UserDelegationEntity;

    for (final event in relevantEvents) {
      if (event.kind == UserMetadataEntity.kind && delegationEntity.data.validate(event)) {
        final userMetadataEntity = eventParser.parse(event) as UserMetadataEntity;
        if (userMetadataEntity.masterPubkey == delegationEntity.pubkey) {
          return userMetadataEntity;
        }
      }
    }
    return null;
  }
}

EventMessage _entityFromEventJson(String stringifiedJson) {
  // TODO:add brotli decompress when BE is impl
  return EventMessage.fromPayloadJson(jsonDecode(stringifiedJson) as Map<String, dynamic>);
}

List<EventMessage> _entityListFromEventListJson(String stringifiedJson) {
  // TODO:add brotli decompress when BE is impl
  return (jsonDecode(stringifiedJson) as List<dynamic>)
      .map(
        (eventJson) => EventMessage.fromPayloadJson(eventJson as Map<String, dynamic>),
      )
      .toList();
}

enum PushNotificationType {
  reply,
  mention,
  repost,
  like,
  follower,
  chatMessage,
  chatReaction,
  paymentRequest,
  paymentReceived,
}
