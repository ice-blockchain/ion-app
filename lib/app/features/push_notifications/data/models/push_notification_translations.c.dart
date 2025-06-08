// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/config/data/models/app_config_with_version.dart';

part 'push_notification_translations.c.freezed.dart';
part 'push_notification_translations.c.g.dart';

@freezed
class PushNotificationTranslations
    with _$PushNotificationTranslations
    implements AppConfigWithVersion {
  const factory PushNotificationTranslations({
    @JsonKey(name: '_version') required int version,
    NotificationTranslation? reply,
    NotificationTranslation? mention,
    NotificationTranslation? repost,
    NotificationTranslation? like,
    NotificationTranslation? follower,
    NotificationTranslation? chatReaction,
    NotificationTranslation? chatMessage,
    NotificationTranslation? paymentRequest,
    NotificationTranslation? paymentReceived,
  }) = _PushNotificationTranslations;

  factory PushNotificationTranslations.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationTranslationsFromJson(json);
}

@freezed
class NotificationTranslation with _$NotificationTranslation {
  const factory NotificationTranslation({
    String? title,
    String? body,
  }) = _NotificationTranslation;

  factory NotificationTranslation.fromJson(Map<String, dynamic> json) =>
      _$NotificationTranslationFromJson(json);
}
