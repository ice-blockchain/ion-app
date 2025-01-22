// SPDX-License-Identifier: ice License 1.0
import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/event_setting.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/community_admin_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/community_moderator_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/community_openness_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/community_visibility_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/description_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/identifier_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/imeta_tag.c.dart';
import 'package:ion/app/features/ion_connect/model/tags/name_tag.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'community_definition_data.c.freezed.dart';

@Freezed(equal: false)
class CommunityDefinitionEntity with _$CommunityDefinitionEntity, IonConnectEntity {
  const factory CommunityDefinitionEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required CommunityDefinitionData data,
  }) = _CommunityDefinitionEntity;

  const CommunityDefinitionEntity._();

  factory CommunityDefinitionEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event kind ${eventMessage.kind}, expected $kind');
    }

    return CommunityDefinitionEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: CommunityDefinitionData.fromEventMessage(eventMessage),
    );
  }

  // https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-3000.md
  static const kind = 31750;
}

@Freezed(equal: false)
class CommunityDefinitionData with _$CommunityDefinitionData implements EventSerializable {
  const factory CommunityDefinitionData({
    required String uuid,
    required String id,
    required bool isPublic,
    required bool isOpen,
    required bool commentsEnabled,
    required RoleRequiredForPosting roleRequiredForPosting,
    required List<String> moderators,
    required List<String> admins,
    required String name,
    required String? description,
    required MediaAttachment? avatar,
    required String owner,
  }) = _CommunityDefinitionData;

  factory CommunityDefinitionData.fromData({
    required String name,
    required String? description,
    required MediaAttachment? avatar,
    required bool isPublic,
    required bool isOpen,
    required bool commentsEnabled,
    required RoleRequiredForPosting roleRequiredForPosting,
    required List<String> moderators,
    required List<String> admins,
  }) {
    final uuid = generateV7UUID();
    return CommunityDefinitionData(
      uuid: uuid,
      id: uuid,
      name: name,
      description: description,
      avatar: avatar,
      isPublic: isPublic,
      isOpen: isOpen,
      commentsEnabled: commentsEnabled,
      roleRequiredForPosting: roleRequiredForPosting,
      moderators: moderators,
      admins: admins,
      owner: '',
    );
  }

  const CommunityDefinitionData._();

  factory CommunityDefinitionData.fromEventMessage(EventMessage eventMessage) {
    return CommunityDefinitionData(
      uuid: CommunityIdentifierTag.fromTags(eventMessage.tags).value,
      id: IdentifierTag.fromTags(eventMessage.tags).value,
      name: NameTag.fromTags(eventMessage.tags).value,
      description: DescriptionTag.fromTags(eventMessage.tags).value,
      avatar: ImetaTag.fromTags(eventMessage.tags).value,
      isPublic: CommunityVisibilityTag.fromTags(eventMessage.tags).isPublic,
      isOpen: CommunityOpennessTag.fromTags(eventMessage.tags).isOpen,
      commentsEnabled: CommentsEnabledEventSetting.fromTags(eventMessage.tags).isEnabled,
      roleRequiredForPosting: RoleRequiredForPostingEventSetting.fromTags(eventMessage.tags).role,
      moderators: CommunityModeratorTag.fromTags(eventMessage.tags).values,
      admins: CommunityAdminTag.fromTags(eventMessage.tags).values,
      owner: eventMessage.masterPubkey,
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: CommunityDefinitionEntity.kind,
      tags: [
        ...tags,
        CommunityIdentifierTag(value: uuid).toTag(),
        IdentifierTag(value: uuid).toTag(),
        NameTag(value: name).toTag(),
        if (description != null) DescriptionTag(value: description).toTag(),
        if (avatar != null) avatar!.toTag(),
        CommunityVisibilityTag(isPublic: isPublic).toTag(),
        CommunityOpennessTag(isOpen: isOpen).toTag(),
        CommentsEnabledEventSetting(isEnabled: commentsEnabled).toTag(),
        RoleRequiredForPostingEventSetting(role: roleRequiredForPosting).toTag(),
        if (moderators.isNotEmpty) ...CommunityModeratorTag(values: moderators).toTag(),
        if (admins.isNotEmpty) ...CommunityAdminTag(values: admins).toTag(),
        ReplaceableEventReference(
          kind: CommunityDefinitionEntity.kind,
          pubkey: owner,
          dTag: uuid,
        ).toTag(),
      ],
      content: '',
    );
  }
}
