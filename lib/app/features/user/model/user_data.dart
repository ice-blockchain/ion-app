// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@Freezed(copyWith: true)
class UserData with _$UserData {
  const factory UserData({
    required String pubkey,
    required String name,
    required String about,
    required String picture,
    String? displayName,
    String? website,
    String? banner,
    @Default(false) bool bot,
    @Default(false) bool verified,
    @Default(false) bool nft,
  }) = _UserData;

  factory UserData.fromEventMessage(EventMessage eventMessage) {
    final userDataContent = UserDataContent.fromJson(
      json.decode(eventMessage.content) as Map<String, dynamic>,
    );

    return UserData(
      pubkey: eventMessage.pubkey,
      name: userDataContent.name,
      about: userDataContent.about,
      picture: userDataContent.picture,
      displayName: userDataContent.displayName,
      website: userDataContent.website,
      banner: userDataContent.banner,
      bot: userDataContent.bot ?? false,
    );
  }

  factory UserData.fromPubkeyOnly(String pubkey) {
    return UserData(
      pubkey: pubkey,
      name: pubkey,
      about: '',
      picture: 'https://www.gravatar.com/avatar',
    );
  }
}

@JsonSerializable(createToJson: true)
class UserDataContent {
  UserDataContent({
    required this.name,
    required this.about,
    required this.picture,
    this.displayName,
    this.website,
    this.banner,
    this.bot,
  });

  factory UserDataContent.fromJson(Map<String, dynamic> json) => _$UserDataContentFromJson(json);

  final String name;

  final String about;

  final String picture;

  @JsonKey(name: 'display_name')
  final String? displayName;

  final String? website;

  final String? banner;

  final bool? bot;

  Map<String, dynamic> toJson() => _$UserDataContentToJson(this);
}
