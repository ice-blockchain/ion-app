// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.f.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.r.dart';
import 'package:ion/app/features/user/model/follow_list.f.dart';
import 'package:ion/app/features/user/model/user_delegation.f.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.f.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.f.dart';

part 'ion_connect_push_data_payload.f.freezed.dart';
part 'ion_connect_push_data_payload.f.g.dart';

class IonConnectPushDataPayload {
  const IonConnectPushDataPayload._({
    required this.event,
    required this.relevantEvents,
    this.decryptedEvent,
  });

  final EventMessage event;
  final EventMessage? decryptedEvent;
  final List<EventMessage> relevantEvents;

  static Future<IonConnectPushDataPayload> fromEncoded(
    Map<String, dynamic> data,
    Future<EventMessage> Function(EventMessage eventMassage) decryptEvent,
  ) async {
    final EncodedIonConnectPushData(:event, :relevantEvents, :compression) =
        EncodedIonConnectPushData.fromJson(data);

    final rawEvent = _decompress(input: event, compression: compression);
    final parsedEvent = EventMessage.fromPayloadJson(jsonDecode(rawEvent) as Map<String, dynamic>);

    final rawRelevantEvents = relevantEvents != null
        ? _decompress(input: relevantEvents, compression: compression)
        : null;
    final parsedRelevantEvents = rawRelevantEvents != null
        ? ((jsonDecode(rawRelevantEvents) as List<dynamic>)
            .map(
              (eventJson) => EventMessage.fromPayloadJson(eventJson as Map<String, dynamic>),
            )
            .toList())
        : <EventMessage>[];

    EventMessage? decryptedEvent;

    if (parsedEvent.kind == IonConnectGiftWrapEntity.kind) {
      final giftWrapEntity = EventParser().parse(parsedEvent) as IonConnectGiftWrapEntity;
      if (giftWrapEntity.data.kinds
          .containsDeep([ReplaceablePrivateDirectMessageEntity.kind.toString()])) {
        decryptedEvent = await decryptEvent(parsedEvent);
      }
    }

    return IonConnectPushDataPayload._(
      event: parsedEvent,
      relevantEvents: parsedRelevantEvents,
      decryptedEvent: decryptedEvent,
    );
  }

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
      if (entity.data.kinds.containsDeep([ReplaceablePrivateDirectMessageEntity.kind.toString()])) {
        if (decryptedEvent == null) return null;

        final message = ReplaceablePrivateDirectMessageEntity.fromEventMessage(decryptedEvent!);
        switch (message.data.messageType) {
          case MessageType.audio:
            return PushNotificationType.chatVoiceMessage;
          case MessageType.document:
            return PushNotificationType.chatDocumentMessage;
          case MessageType.text || MessageType.emoji:
            return PushNotificationType.chatTextMessage;
          case MessageType.profile:
            return PushNotificationType.chatProfileMessage;
          case MessageType.sharedPost:
            return PushNotificationType.chatSharePostMessage;
          case MessageType.visualMedia:
            final mediaItems = message.data.media.values.toList();
            if (mediaItems.every((media) => media.mediaType == MediaType.image)) {
              return PushNotificationType.chatPhotoMessage;
            } else if (mediaItems.every((media) => media.mediaType == MediaType.video)) {
              return PushNotificationType.chatVideoMessage;
            } else {
              return PushNotificationType.chatAlbumMessage;
            }
          case MessageType.requestFunds:
            return PushNotificationType.paymentRequest;
          case MessageType.moneySent:
            return PushNotificationType.paymentReceived;
        }
      } else if (entity.data.kinds.containsDeep([ReactionEntity.kind.toString()])) {
        return PushNotificationType.chatReaction;
      } else if (entity.data.kinds.containsDeep([FundsRequestEntity.kind.toString()])) {
        return PushNotificationType.paymentRequest;
      } else if (entity.data.kinds.containsDeep([WalletAssetEntity.kind.toString()])) {
        return PushNotificationType.paymentReceived;
      }
    }

    return null;
  }

  Map<String, String> get placeholders {
    final mainEntityUserMetadata = _getUserMetadata(pubkey: mainEntity.masterPubkey);

    final data = <String, String>{};

    if (mainEntityUserMetadata != null) {
      data.addAll({
        'username': mainEntityUserMetadata.data.name,
        'displayName': mainEntityUserMetadata.data.displayName,
      });
    }

    if (decryptedEvent != null) {
      data['messageContent'] = decryptedEvent!.content;
    }

    return data;
  }

  Future<bool> validate({required String currentPubkey}) async {
    return await _checkEventsSignatures() &&
        _checkMainEventRelevant(currentPubkey: currentPubkey) &&
        _checkRequiredRelevantEvents();
  }

  static String _decompress({required String input, required Compression compression}) {
    return switch (compression) {
      Compression.zlib => utf8.decode(zlib.decode(base64.decode(input))),
      Compression.none => input,
    };
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

@Freezed(toJson: false)
class EncodedIonConnectPushData with _$EncodedIonConnectPushData {
  const factory EncodedIonConnectPushData({
    required String event,
    @JsonKey(name: 'relevant_events') String? relevantEvents,
    @Default(Compression.none) Compression compression,
  }) = _EncodedIonConnectPushData;

  factory EncodedIonConnectPushData.fromJson(Map<String, dynamic> json) =>
      _$EncodedIonConnectPushDataFromJson(json);
}

enum Compression {
  none,
  zlib,
}

enum PushNotificationType {
  reply,
  mention,
  repost,
  like,
  follower,
  paymentRequest,
  paymentReceived,
  chatDocumentMessage,
  chatEmojiMessage,
  chatPhotoMessage,
  chatProfileMessage,
  chatReaction,
  chatSharePostMessage,
  chatShareStoryMessage,
  chatSharedStoryReplyMessage,
  chatTextMessage,
  chatVideoMessage,
  chatVoiceMessage,
  chatAlbumMessage,
}
