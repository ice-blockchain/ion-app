// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/push_notifications/background/app_translations_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion/app/utils/string.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationsService = LocalNotificationsService();
  await notificationsService.initialize();
  IonConnect.initialize(null);

  if (message.notification != null) {
    return;
  }

  final data = IonConnectPushDataPayload.fromJson(message.data);
  final parsedData = await _parseNotificationData(data);

  await notificationsService.showNotification(
    id: message.messageId.hashCode,
    title: parsedData?.title ?? data.title,
    body: parsedData?.body ?? data.body,
    payload: message.data.toString(),
  );
}

Future<({String title, String body})?> _parseNotificationData(
  IonConnectPushDataPayload data,
) async {
  final parser = EventParser();
  final riverpod = ProviderContainer(observers: [Logger.talkerRiverpodObserver]);
  final translator = await riverpod.read(translatorProvider.future);

  final prefs = await riverpod.read(sharedPreferencesFoundationProvider.future);
  final currentPubkey = await prefs.getString(CurrentPubkeySelector.persistenceKey);

  if (currentPubkey == null) {
    return null;
  }

  final mainEntity = await data.event.validate() ? parser.parse(data.event) : null;
  final validRelatedEvents = await Future.wait(
    data.relatedEvents.map((event) async => await event.validate() ? event : null),
  );

  if (mainEntity == null) {
    return null;
  }

  final mainEntityUserMetadata = _getUserMetadata(
    pubkey: mainEntity.masterPubkey,
    relatedEvents: validRelatedEvents.nonNulls.toList(),
  );

  final notificationType =
      await _getNotificationType(mainEntity: mainEntity, currentPubkey: currentPubkey);

  if (notificationType == null) {
    return null;
  }

  final (title, body) =
      await _getNotificationTranslation(notificationType: notificationType, translator: translator);

// TODO: make generc
  final body1 = body != null
      ? mainEntityUserMetadata != null
          ? replacePlaceholders(
              body,
              {'username': mainEntityUserMetadata.data.displayName},
            )
          : body
      : data.body;

  final title1 = title != null
      ? mainEntityUserMetadata != null
          ? replacePlaceholders(
              title,
              {'username': mainEntityUserMetadata.data.displayName},
            )
          : title
      : data.title;

  return (title: title1, body: body1);
}

UserMetadataEntity? _getUserMetadata({
  required String pubkey,
  required List<EventMessage> relatedEvents,
}) {
  final delegationEvent = relatedEvents.firstWhereOrNull((event) {
    return event.kind == UserDelegationEntity.kind && event.pubkey == pubkey;
  });
  if (delegationEvent == null) {
    return null;
  }
  final eventParser = EventParser();
  final delegationEntity = eventParser.parse(delegationEvent) as UserDelegationEntity;

  for (final event in relatedEvents) {
    if (event.kind == UserMetadataEntity.kind && delegationEntity.data.validate(event)) {
      final userMetadataEntity = eventParser.parse(event) as UserMetadataEntity;
      if (userMetadataEntity.masterPubkey == delegationEntity.pubkey) {
        return userMetadataEntity;
      }
    }
  }
  return null;
}

Future<NotificationType?> _getNotificationType({
  required IonConnectEntity mainEntity,
  required String currentPubkey,
}) async {
  if (mainEntity is ModifiablePostEntity) {
    final relatedPubkeys = mainEntity.data.relatedPubkeys;
    if (relatedPubkeys != null &&
        relatedPubkeys.any((relatedPubkey) => relatedPubkey.value == currentPubkey)) {
      final isMention = mainEntity.data.content.contains(
        ReplaceableEventReference(pubkey: currentPubkey, kind: UserMetadataEntity.kind).encode(),
      );
      return isMention ? NotificationType.mention : NotificationType.reply;
    }
  } else if (mainEntity is GenericRepostEntity &&
      mainEntity.data.eventReference.pubkey == currentPubkey) {
    return NotificationType.repost;
  } else if (mainEntity is RepostEntity && mainEntity.data.eventReference.pubkey == currentPubkey) {
    return NotificationType.repost;
  } else if (mainEntity is ReactionEntity &&
      mainEntity.data.eventReference.pubkey == currentPubkey) {
    return NotificationType.like;
  } else if (mainEntity is FollowListEntity && mainEntity.pubkeys.lastOrNull == currentPubkey) {
    return NotificationType.follower;
  } else if (mainEntity is IonConnectGiftWrapEntity &&
      mainEntity.data.relatedPubkeys.any((relatedPubkey) => relatedPubkey.value == currentPubkey)) {
    if (mainEntity.data.kinds.contains(ModifiablePostEntity.kind.toString())) {
      return NotificationType.chatMessage;
    } else if (mainEntity.data.kinds.contains(ReactionEntity.kind.toString())) {
      return NotificationType.chatReaction;
    } else if (mainEntity.data.kinds.contains(FundsRequestEntity.kind.toString())) {
      return NotificationType.paymentRequest;
    } else if (mainEntity.data.kinds.contains(WalletAssetEntity.kind.toString())) {
      return NotificationType.paymentReceived;
    }
  }
  return null;
}

Future<(String? title, String? body)> _getNotificationTranslation({
  required NotificationType notificationType,
  required Translator translator,
}) async {
  try {
    return switch (notificationType) {
      NotificationType.reply => await (
          translator.translate((translations) => translations.pushNotifications?.reply?.title),
          translator.translate((translations) => translations.pushNotifications?.reply?.body),
        ).wait,
      NotificationType.mention => (
          translator.translate((translations) => translations.pushNotifications?.mention?.title),
          translator.translate((translations) => translations.pushNotifications?.mention?.body)
        ).wait,
      NotificationType.repost => (
          translator.translate((translations) => translations.pushNotifications?.repost?.title),
          translator.translate((translations) => translations.pushNotifications?.repost?.body)
        ).wait,
      NotificationType.like => (
          translator.translate((translations) => translations.pushNotifications?.like?.title),
          translator.translate((translations) => translations.pushNotifications?.like?.body)
        ).wait,
      NotificationType.follower => (
          translator.translate((translations) => translations.pushNotifications?.follower?.title),
          translator.translate((translations) => translations.pushNotifications?.follower?.body)
        ).wait,
      NotificationType.chatReaction => (
          translator
              .translate((translations) => translations.pushNotifications?.chatReaction?.title),
          translator.translate((translations) => translations.pushNotifications?.chatReaction?.body)
        ).wait,
      NotificationType.chatMessage => (
          translator
              .translate((translations) => translations.pushNotifications?.chatMessage?.title),
          translator.translate((translations) => translations.pushNotifications?.chatMessage?.body)
        ).wait,
      NotificationType.paymentRequest => (
          translator
              .translate((translations) => translations.pushNotifications?.paymentRequest?.title),
          translator
              .translate((translations) => translations.pushNotifications?.paymentRequest?.body)
        ).wait,
      NotificationType.paymentReceived => (
          translator
              .translate((translations) => translations.pushNotifications?.paymentReceived?.title),
          translator
              .translate((translations) => translations.pushNotifications?.paymentReceived?.body)
        ).wait,
    };
  } catch (error) {
    return (null, null);
  }
}

void initFirebaseMessagingBackgroundHandler() {
  if (!kIsWeb && Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

enum NotificationType {
  reply,
  mention,
  repost,
  like,
  follower,
  chatMessage,
  chatReaction,
  paymentRequest,
  paymentReceived,
}
