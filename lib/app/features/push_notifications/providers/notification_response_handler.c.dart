// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/data/models/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/push_notifications/data/models/ion_connect_push_data_payload.c.dart';
import 'package:ion/app/features/push_notifications/providers/notification_response_data_provider.c.dart';
import 'package:ion/app/features/user/data/models/follow_list.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_response_handler.c.g.dart';

@Riverpod(keepAlive: true)
class NotificationResponseHandler extends _$NotificationResponseHandler {
  @override
  FutureOr<void> build() async {
    final notificationResponses = ref.watch(notificationResponseDataProvider);
    final notificationResponse = notificationResponses.firstOrNull;
    if (notificationResponse != null) {
      await _handleNotificationResponse(notificationResponse);
    }
  }

  Future<void> _handleNotificationResponse(Map<String, dynamic> response) async {
    try {
      final notificationPayload = await IonConnectPushDataPayload.fromEncoded(response);
      final eventParser = ref.read(eventParserProvider);
      final entity = eventParser.parse(notificationPayload.event);

      switch (entity) {
        case ModifiablePostEntity():
        case PostEntity():
          await _openPostDetail(entity.toEventReference());
        case GenericRepostEntity() when entity.data.kind == ArticleEntity.kind:
          await _openArticleDetail(entity.data.eventReference);
        case GenericRepostEntity() when entity.data.kind == ModifiablePostEntity.kind:
          await _openPostDetail(entity.data.eventReference);
        case RepostEntity():
          await _openPostDetail(entity.data.eventReference);
        case ReactionEntity():
          await _openPostDetail(entity.data.eventReference);
        case FollowListEntity():
          await _openProfileDetail(entity.masterPubkey);
        case IonConnectGiftWrapEntity():
          await _handleGiftWrap(notificationPayload.event);
        default:
          throw UnsupportedEntityType(entity);
      }

      ref.watch(notificationResponseDataProvider.notifier).removeFirst();
    } catch (error, stackTrace) {
      Logger.error(error, stackTrace: stackTrace, message: 'Error handling notification response');
    } finally {
      ref.read(notificationResponseDataProvider.notifier).removeFirst();
    }
  }

  Future<void> _handleGiftWrap(EventMessage giftWrap) async {
    final giftUnwrapService = await ref.watch(giftUnwrapServiceProvider.future);
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final rumor = await giftUnwrapService.unwrap(giftWrap);

    switch (rumor.kind) {
      case ReplaceablePrivateDirectMessageEntity.kind:
      case PrivateMessageReactionEntity.kind:
      case FundsRequestEntity.kind:
      case WalletAssetEntity.kind:
        await _openChat(rumor.masterPubkey);
      default:
        throw UnsupportedEntityType(rumor);
    }
  }

  Future<void> _openPostDetail(EventReference eventReference) async {
    await PostDetailsRoute(eventReference: eventReference.encode())
        .push<void>(rootNavigatorKey.currentContext!);
  }

  Future<void> _openArticleDetail(EventReference eventReference) async {
    await ArticleDetailsRoute(eventReference: eventReference.encode())
        .push<void>(rootNavigatorKey.currentContext!);
  }

  Future<void> _openProfileDetail(String pubkey) async {
    await ProfileRoute(pubkey: pubkey).push<void>(rootNavigatorKey.currentContext!);
  }

  Future<void> _openChat(String pubkey) async {
    await ConversationRoute(receiverPubKey: pubkey).push<void>(rootNavigatorKey.currentContext!);
  }
}
