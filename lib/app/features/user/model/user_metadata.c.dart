// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';

part 'user_metadata.c.freezed.dart';
part 'user_metadata.c.g.dart';

@Freezed(equal: false)
class UserMetadataEntity
    with IonConnectEntity, CacheableEntity, ReplaceableEntity, _$UserMetadataEntity {
  const factory UserMetadataEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required UserMetadata data,
  }) = _UserMetadataEntity;

  const UserMetadataEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/01.md#kinds
  factory UserMetadataEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return UserMetadataEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: UserMetadata.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 0;
}

@freezed
class UserMetadata with _$UserMetadata implements EventSerializable, ReplaceableEntityData {
  const factory UserMetadata({
    @Default('') String name,
    @Default('') String displayName,
    String? about,
    String? picture,
    String? website,
    String? location,
    String? category,
    DateTime? registeredAt,
    String? banner,
    @Default({}) Map<String, MediaAttachment> media,
    Map<String, String>? wallets,
    WhoCanSetting? whoCanMessageYou,
    WhoCanSetting? whoCanInviteYouToGroups,
  }) = _UserMetadata;

  const UserMetadata._();

  factory UserMetadata.fromEventMessage(EventMessage eventMessage) {
    final content = eventMessage.content;
    if (content == null) {
      throw IncorrectEventContentException(eventId: eventMessage.id);
    }

    final userDataContent = UserDataEventMessageContent.fromJson(
      json.decode(content) as Map<String, dynamic>,
    );

    final media = eventMessage.tags.fold(<String, MediaAttachment>{}, (res, tag) {
      if (tag[0] == MediaAttachment.tagName) {
        final attachment = MediaAttachment.fromTag(tag);
        return {...res, attachment.url: attachment};
      }
      return res;
    });

    return UserMetadata(
      name: userDataContent.name ?? '',
      displayName: userDataContent.displayName ?? '',
      about: userDataContent.about,
      picture: userDataContent.picture,
      website: userDataContent.website,
      banner: userDataContent.banner,
      location: userDataContent.location,
      category: userDataContent.category,
      registeredAt: userDataContent.registeredAt,
      media: media,
      whoCanMessageYou: WhoCanSetting.fromString(userDataContent.whoCanMessageYou),
      whoCanInviteYouToGroups: WhoCanSetting.fromString(userDataContent.whoCanInviteYouToGroups),
      wallets: userDataContent.wallets,
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
      kind: UserMetadataEntity.kind,
      content: jsonEncode(
        UserDataEventMessageContent(
          name: name,
          about: about,
          picture: picture,
          displayName: displayName,
          website: website,
          banner: banner,
          location: location,
          category: category,
          registeredAt: registeredAt,
          whoCanMessageYou: whoCanMessageYou?.name,
          whoCanInviteYouToGroups: whoCanInviteYouToGroups?.name,
          wallets: wallets,
        ).toJson(),
      ),
      tags: [
        ...tags,
        for (final attachment in media.values) attachment.toTag(),
      ],
    );
  }

  @override
  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      kind: UserMetadataEntity.kind,
      pubkey: pubkey,
    );
  }
}

@JsonSerializable(createToJson: true, includeIfNull: false)
class UserDataEventMessageContent {
  UserDataEventMessageContent({
    this.name,
    this.about,
    this.picture,
    this.displayName,
    this.website,
    this.location,
    this.category,
    this.registeredAt,
    this.banner,
    this.whoCanMessageYou,
    this.whoCanInviteYouToGroups,
    this.wallets,
  });

  factory UserDataEventMessageContent.fromJson(Map<String, dynamic> json) =>
      _$UserDataEventMessageContentFromJson(json);

  final String? name;

  final String? about;

  final String? picture;

  @JsonKey(name: 'display_name')
  final String? displayName;

  final String? website;

  final String? location;

  final String? category;

  @JsonKey(
    name: 'registered_at',
    toJson: _dateTimeToJson,
    fromJson: _dateTimeFromJson,
  )
  final DateTime? registeredAt;

  final String? banner;

  @JsonKey(name: 'who_can_message_you')
  final String? whoCanMessageYou;

  @JsonKey(name: 'who_can_invite_you_to_groups')
  final String? whoCanInviteYouToGroups;

  final Map<String, String>? wallets;

  Map<String, dynamic> toJson() => _$UserDataEventMessageContentToJson(this);

  static int? _dateTimeToJson(DateTime? value) =>
      value != null ? value.millisecondsSinceEpoch ~/ 1000 : null;

  static DateTime? _dateTimeFromJson(int? value) =>
      value != null ? DateTime.fromMillisecondsSinceEpoch(value * 1000) : null;
}

enum WhoCanSetting {
  everyone,
  follows,
  friends;

  static WhoCanSetting? fromString(String? value) => value == null
      ? null
      : WhoCanSetting.values.firstWhere(
          (element) => element.name == value,
          orElse: () => WhoCanSetting.everyone,
        );
}
