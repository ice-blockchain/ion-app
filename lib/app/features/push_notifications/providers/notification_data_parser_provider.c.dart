// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/features/push_notifications/providers/app_translations_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/utils/string.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_data_parser_provider.c.g.dart';

class NotificationDataParser {
  NotificationDataParser({
    required Translator<PushNotificationTranslations> translator,
    required SharedPreferencesAsync prefs,
  })  : _translator = translator,
        _prefs = prefs;

  final SharedPreferencesAsync _prefs;
  final Translator<PushNotificationTranslations> _translator;

  Future<({String title, String body})?> parse(
    IonConnectPushDataPayload data,
  ) async {
    // reading from shared prefs because this method might be used from a background service
    final currentPubkey = await _prefs.getString(CurrentPubkeySelector.persistenceKey);

    if (currentPubkey == null) {
      return null;
    }

    final dataIsValid = await data.validate(currentPubkey: currentPubkey);

    if (!dataIsValid) {
      return null;
    }

    final notificationType = data.getNotificationType(currentPubkey: currentPubkey);

    if (notificationType == null) {
      return null;
    }

    final (title, body) = await _getNotificationTranslation(
      notificationType: notificationType,
      translator: _translator,
    );

    if (title == null || body == null) {
      return null;
    }

    final placeholders = data.placeholders;
    final result = (
      title: replacePlaceholders(title, placeholders),
      body: replacePlaceholders(body, placeholders)
    );

    // If not all the placeholders were replaced
    if (hasPlaceholders(result.title) || hasPlaceholders(result.body)) {
      return null;
    }

    return result;
  }

  Future<(String? title, String? body)> _getNotificationTranslation({
    required PushNotificationType notificationType,
    required Translator<PushNotificationTranslations> translator,
  }) async {
    try {
      return switch (notificationType) {
        PushNotificationType.reply => (
            await translator.translate((t) => t.reply?.title),
            await translator.translate((t) => t.reply?.body),
          ),
        PushNotificationType.mention => (
            await translator.translate((t) => t.mention?.title),
            await translator.translate((t) => t.mention?.body)
          ),
        PushNotificationType.repost => (
            await translator.translate((t) => t.repost?.title),
            await translator.translate((t) => t.repost?.body)
          ),
        PushNotificationType.like => (
            await translator.translate((t) => t.like?.title),
            await translator.translate((t) => t.like?.body)
          ),
        PushNotificationType.follower => (
            await translator.translate((t) => t.follower?.title),
            await translator.translate((t) => t.follower?.body)
          ),
        PushNotificationType.paymentRequest => (
            await translator.translate((t) => t.paymentRequest?.title),
            await translator.translate((t) => t.paymentRequest?.body)
          ),
        PushNotificationType.paymentReceived => (
            await translator.translate((t) => t.paymentReceived?.title),
            await translator.translate((t) => t.paymentReceived?.body)
          ),
        PushNotificationType.chatDocumentMessage => (
            await translator.translate((t) => t.chatDocumentMessage?.title),
            await translator.translate((t) => t.chatDocumentMessage?.body)
          ),
        PushNotificationType.chatEmojiMessage => (
            await translator.translate((t) => t.chatEmojiMessage?.title),
            await translator.translate((t) => t.chatEmojiMessage?.body)
          ),
        PushNotificationType.chatPhotoMessage => (
            await translator.translate((t) => t.chatPhotoMessage?.title),
            await translator.translate((t) => t.chatPhotoMessage?.body)
          ),
        PushNotificationType.chatProfileMessage => (
            await translator.translate((t) => t.chatProfileMessage?.title),
            await translator.translate((t) => t.chatProfileMessage?.body)
          ),
        PushNotificationType.chatReaction => (
            await translator.translate((t) => t.chatReaction?.title),
            await translator.translate((t) => t.chatReaction?.body)
          ),
        PushNotificationType.chatSharePostMessage => (
            await translator.translate((t) => t.chatSharePostMessage?.title),
            await translator.translate((t) => t.chatSharePostMessage?.body)
          ),
        PushNotificationType.chatShareStoryMessage => (
            await translator.translate((t) => t.chatShareStoryMessage?.title),
            await translator.translate((t) => t.chatShareStoryMessage?.body)
          ),
        PushNotificationType.chatSharedStoryReplyMessage => (
            await translator.translate((t) => t.chatSharedStoryReplyMessage?.title),
            await translator.translate((t) => t.chatSharedStoryReplyMessage?.body)
          ),
        PushNotificationType.chatTextMessage => (
            await translator.translate((t) => t.chatTextMessage?.title),
            await translator.translate((t) => t.chatTextMessage?.body)
          ),
        PushNotificationType.chatVideoMessage => (
            await translator.translate((t) => t.chatVideoMessage?.title),
            await translator.translate((t) => t.chatVideoMessage?.body)
          ),
        PushNotificationType.chatVoiceMessage => (
            await translator.translate((t) => t.chatVoiceMessage?.title),
            await translator.translate((t) => t.chatVoiceMessage?.body)
          ),
        PushNotificationType.chatAlbumMessage => (
            await translator.translate((t) => t.chatAlbumMessage?.title),
            await translator.translate((t) => t.chatAlbumMessage?.body)
          ),
      };
    } catch (error) {
      return (null, null);
    }
  }
}

@riverpod
Future<NotificationDataParser> notificationDataParser(Ref ref) async {
  final translator = await ref.read(pushTranslatorProvider.future);
  final prefs = await ref.read(sharedPreferencesFoundationProvider.future);

  return NotificationDataParser(
    translator: translator,
    prefs: prefs,
  );
}
