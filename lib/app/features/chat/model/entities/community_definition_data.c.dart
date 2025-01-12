// SPDX-License-Identifier: ice License 1.0
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:uuid/uuid.dart';

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
    required bool isPublic,
    required bool isOpen,
    required bool commentsEnabled,
    required RoleRequiredForPosting roleRequiredForPosting,
    required List<String> moderators,
    required List<String> admins,
    required String name,
    required String description,
    String? avatarUrl,
  }) = _CommunityDefinitionData;

  const CommunityDefinitionData._();

  factory CommunityDefinitionData.fromEventMessage(EventMessage eventMessage) {
    return CommunityDefinitionData(
      uuid: eventMessage.tags.firstWhere((tag) => tag[0] == 'h').last,
      isPublic: eventMessage.tags.firstWhere((tag) => tag[0] == 'public').isNotEmpty,
      isOpen: eventMessage.tags.firstWhere((tag) => tag[0] == 'open').isNotEmpty,
      commentsEnabled: eventMessage.tags
              .firstWhere((tag) => tag[0] == 'settings' && tag[1] == 'comments_enabled')
              .last ==
          'true',
      roleRequiredForPosting: RoleRequiredForPosting.values.firstWhere(
        (role) =>
            role.name ==
            eventMessage.tags
                .firstWhere((tag) => tag[0] == 'settings' && tag[1] == 'role_required_for_posting')
                .last,
      ),
      moderators: eventMessage.tags
          .where((tag) => tag[0] == 'p' && tag.last == 'moderator')
          .map((tag) => tag[1])
          .toList(),
      admins: eventMessage.tags
          .where((tag) => tag[0] == 'p' && tag.last == 'admin')
          .map((tag) => tag[1])
          .toList(),
      name: eventMessage.tags.firstWhere((tag) => tag[0] == 'name').last,
      description: eventMessage.tags.firstWhere((tag) => tag[0] == 'description').last,
      avatarUrl: eventMessage.tags.firstWhereOrNull((tag) => tag[0] == 'imeta')?.last,
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
        ['h', uuid],
        ['name', name],
        ['description', description],
        if (avatarUrl != null) ['imeta', avatarUrl!],
        if (isPublic) ['public'] else ['private'],
        if (isOpen) ['open'] else ['closed'],
        [
          'settings',
          'comments_enabled',
          if (commentsEnabled) 'true' else 'false',
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        ],
        [
          'settings',
          'role_required_for_posting',
          roleRequiredForPosting.name,
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        ],
        ...moderators.map((moderator) => ['p', moderator]),
        ...admins.map((admin) => ['p', admin]),
      ],
      content: '',
    );
  }
}

String generateV7UUID() {
  return const Uuid().v7();
}

enum RoleRequiredForPosting {
  admin,
  moderator,
}
