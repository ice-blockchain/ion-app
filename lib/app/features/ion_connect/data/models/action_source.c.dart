// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_source.c.freezed.dart';

@freezed
sealed class ActionSource with _$ActionSource {
  const factory ActionSource.currentUser({
    @Default(false) bool anonymous,
  }) = ActionSourceCurrentUser;

  const factory ActionSource.user(
    String pubkey, {
    @Default(false) bool anonymous,
  }) = ActionSourceUser;

  const factory ActionSource.relayUrl(
    String url, {
    @Default(false) bool anonymous,
  }) = ActionSourceRelayUrl;

  const factory ActionSource.indexers({
    @Default(false) bool anonymous,
  }) = ActionSourceIndexers;

  const factory ActionSource.userChat(
    String pubkey, {
    @Default(false) bool anonymous,
  }) = ActionSourceUserChat;

  const factory ActionSource.currentUserChat({
    @Default(false) bool anonymous,
  }) = ActionSourceCurrentUserChat;
}
