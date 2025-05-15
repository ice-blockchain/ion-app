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

    final placeholders = data.placeholders;

    return (
      title: replacePlaceholders(title ?? data.title, placeholders),
      body: replacePlaceholders(body ?? data.body, placeholders)
    );
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
        PushNotificationType.chatReaction => (
            await translator.translate((t) => t.chatReaction?.title),
            await translator.translate((t) => t.chatReaction?.body)
          ),
        PushNotificationType.chatMessage => (
            await translator.translate((t) => t.chatMessage?.title),
            await translator.translate((t) => t.chatMessage?.body)
          ),
        PushNotificationType.paymentRequest => (
            await translator.translate((t) => t.paymentRequest?.title),
            await translator.translate((t) => t.paymentRequest?.body)
          ),
        PushNotificationType.paymentReceived => (
            await translator.translate((t) => t.paymentReceived?.title),
            await translator.translate((t) => t.paymentReceived?.body)
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
