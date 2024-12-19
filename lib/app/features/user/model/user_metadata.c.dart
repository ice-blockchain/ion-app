// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_metadata.c.freezed.dart';
part 'user_metadata.c.g.dart';

@Freezed(equal: false)
class UserMetadataEntity with _$UserMetadataEntity, NostrEntity implements CacheableEntity {
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
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
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

  @override
  String get cacheKey => cacheKeyBuilder(pubkey: masterPubkey);

  static String cacheKeyBuilder({required String pubkey}) => '$kind:$pubkey';

  static const int kind = 0;
}

@freezed
class UserMetadata with _$UserMetadata implements EventSerializable {
  const factory UserMetadata({
    @Default('') String name,
    @Default('') String displayName,
    String? about,
    String? picture,
    String? website,
    String? banner,
    @Default({}) Map<String, MediaAttachment> media,
  }) = _UserMetadata;

  const UserMetadata._();

  factory UserMetadata.fromEventMessage(EventMessage eventMessage) {
    final userDataContent = UserDataEventMessageContent.fromJson(
      json.decode(eventMessage.content) as Map<String, dynamic>,
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
      media: media,
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
        ).toJson(),
      ),
      tags: [
        ...tags,
        for (final attachment in media.values) attachment.toTag(),
      ],
    );
  }
}

@JsonSerializable(createToJson: true)
class UserDataEventMessageContent {
  UserDataEventMessageContent({
    this.name,
    this.about,
    this.picture,
    this.displayName,
    this.website,
    this.banner,
  });

  factory UserDataEventMessageContent.fromJson(Map<String, dynamic> json) =>
      _$UserDataEventMessageContentFromJson(json);

  final String? name;

  final String? about;

  final String? picture;

  @JsonKey(name: 'display_name')
  final String? displayName;

  final String? website;

  final String? banner;

  Map<String, dynamic> toJson() => _$UserDataEventMessageContentToJson(this);
}
