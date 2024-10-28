// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_metadata.freezed.dart';
part 'user_metadata.g.dart';

@freezed
class UserMetadata with _$UserMetadata, CacheableEvent {
  const factory UserMetadata({
    required String pubkey,
    @Default('') String name,
    @Default('') String displayName,
    String? about,
    String? picture,
    String? website,
    String? banner,
    @Default({}) Map<String, MediaAttachment> media,
    @Default(false) bool bot,
    @Default(false) bool verified,
    @Default(false) bool nft,
  }) = _UserMetadata;

  /// https://github.com/nostr-protocol/nips/blob/master/01.md#kinds
  factory UserMetadata.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

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
      pubkey: eventMessage.pubkey,
      name: userDataContent.name ?? '',
      displayName: userDataContent.displayName ?? '',
      about: userDataContent.about,
      picture: userDataContent.picture,
      website: userDataContent.website,
      banner: userDataContent.banner,
      bot: userDataContent.bot ?? false,
      media: media,
    );
  }

  const UserMetadata._();

  EventMessage toEventMessage(KeyStore keyStore) {
    return EventMessage.fromData(
      signer: keyStore,
      kind: kind,
      content: jsonEncode(
        UserDataEventMessageContent(
          name: name,
          about: about,
          picture: picture,
          displayName: displayName,
          website: website,
          banner: banner,
          bot: bot,
        ).toJson(),
      ),
      tags: media.values.map((attachment) => attachment.toJson()).toList(),
    );
  }

  @override
  String get cacheKey => pubkey;

  @override
  Type get cacheType => UserMetadata;

  static const int kind = 0;
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
    this.bot,
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

  final bool? bot;

  Map<String, dynamic> toJson() => _$UserDataEventMessageContentToJson(this);
}
