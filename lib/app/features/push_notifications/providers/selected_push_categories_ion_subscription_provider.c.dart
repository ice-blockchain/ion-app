// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/related_relay.c.dart';
import 'package:ion/app/features/ion_connect/model/related_token.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_notification_category.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription_platform.c.dart';
import 'package:ion/app/features/push_notifications/providers/configure_firebase_messaging_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/firebase_messaging_token_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/relay_firebase_app_config_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/selected_push_categories_provider.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/services/device_id/device_id.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_push_categories_ion_subscription_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SelectedPushCategoriesIonSubscription extends _$SelectedPushCategoriesIonSubscription {
  @override
  Future<PushSubscriptionData?> build() async {
    final relaysFirebaseConfig = await ref.watch(relayFirebaseAppConfigProvider.future);
    final fcmConfigured = await ref.watch(configureFirebaseMessagingProvider.future);

    if (relaysFirebaseConfig == null || !fcmConfigured) {
      return null;
    }

    final encryptedFcmToken =
        await _getEncryptedFcmToken(relayPubkey: relaysFirebaseConfig.relayPubkey);
    if (encryptedFcmToken == null) {
      return null;
    }

    return PushSubscriptionData(
      deviceId: await ref.watch(deviceIdServiceProvider).get(),
      platform: PushSubscriptionPlatform.forPlatform(),
      relay: RelatedRelay(url: relaysFirebaseConfig.relayUrl),
      fcmToken: RelatedToken(value: encryptedFcmToken),
      filters: await _getFilters(),
    );
  }

  Future<String?> _getEncryptedFcmToken({required String relayPubkey}) async {
    final fcmToken = await ref.watch(firebaseMessagingTokenProvider.future);
    if (fcmToken == null) {
      return null;
    }

    return fcmToken;
    // TODO: do not encrypt it for now until BE is ready
    // final encryptedMessageService = await ref.watch(encryptedMessageServiceProvider.future);
    // return encryptedMessageService.encryptMessage(fcmToken, publicKey: relayPubkey);
  }

  Future<List<RequestFilter>> _getFilters() async {
    final selectedPushCategories = ref.watch(selectedPushCategoriesProvider);
    return selectedPushCategories.enabledCategories
        .map(_buildFilterForCategory)
        .nonNulls
        .expand<RequestFilter>((filters) => filters)
        .toList();
  }

  List<RequestFilter>? _buildFilterForCategory(PushNotificationCategory category) {
    return switch (category) {
      PushNotificationCategory.mentionsAndReplies => _buildFilterForMentionsAndReplies(),
      PushNotificationCategory.reposts => _buildFilterForReposts(),
      PushNotificationCategory.likes => _buildFilterForLikes(),
      PushNotificationCategory.newFollowers => _buildFilterForNewFollowers(),
      PushNotificationCategory.directMessages => _buildFilterForDirectMessages(),
      PushNotificationCategory.paymentRequest => _buildFilterForPaymentRequest(),
      PushNotificationCategory.paymentReceived => _buildFilterForPaymentReceived(),
      _ => null,
    };
  }

  List<RequestFilter> _buildFilterForMentionsAndReplies() {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) throw UserMasterPubkeyNotFoundException();
    return [
      RequestFilter(
        kinds: const [ModifiablePostEntity.kind, ArticleEntity.kind],
        tags: {
          '#p': [currentUserPubkey],
        },
      ),
    ];
  }

  List<RequestFilter> _buildFilterForReposts() {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) throw UserMasterPubkeyNotFoundException();
    return [
      RequestFilter(
        kinds: const [GenericRepostEntity.kind],
        tags: {
          '#p': [currentUserPubkey],
          '#k': [ModifiablePostEntity.kind.toString(), ArticleEntity.kind.toString()],
        },
      ),
      RequestFilter(
        kinds: const [RepostEntity.kind],
        tags: {
          '#p': [currentUserPubkey],
        },
      ),
      RequestFilter(
        kinds: const [ModifiablePostEntity.kind],
        tags: {
          '#Q': [
            [null, null, currentUserPubkey],
          ],
        },
      ),
      RequestFilter(
        kinds: const [PostEntity.kind],
        tags: {
          '#q': [
            [null, null, currentUserPubkey],
          ],
        },
      ),
    ];
  }

  List<RequestFilter> _buildFilterForLikes() {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) throw UserMasterPubkeyNotFoundException();
    return [
      RequestFilter(
        kinds: const [ReactionEntity.kind],
        tags: {
          '#p': [currentUserPubkey],
        },
      ),
      RequestFilter(
        kinds: const [IonConnectGiftWrapServiceImpl.kind],
        tags: {
          '#k': [
            PrivateMessageReactionEntity.kind.toString(),
          ],
          '#p': [currentUserPubkey],
        },
      ),
    ];
  }

  List<RequestFilter> _buildFilterForNewFollowers() {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) throw UserMasterPubkeyNotFoundException();
    return [
      RequestFilter(
        kinds: const [FollowListEntity.kind],
        tags: {
          '#p': [currentUserPubkey],
        },
      ),
    ];
  }

  List<RequestFilter> _buildFilterForDirectMessages() {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) throw UserMasterPubkeyNotFoundException();
    return [
      RequestFilter(
        kinds: const [IonConnectGiftWrapServiceImpl.kind],
        tags: {
          '#k': [
            ReplaceablePrivateDirectMessageEntity.kind.toString(),
            ImmutablePrivateDirectMessageEntity.kind.toString(),
          ],
          '#p': [currentUserPubkey],
        },
      ),
    ];
  }

  List<RequestFilter> _buildFilterForPaymentRequest() {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) throw UserMasterPubkeyNotFoundException();
    return [
      RequestFilter(
        kinds: const [IonConnectGiftWrapServiceImpl.kind],
        tags: {
          '#k': [FundsRequestEntity.kind.toString()],
          '#p': [currentUserPubkey],
        },
      ),
    ];
  }

  List<RequestFilter> _buildFilterForPaymentReceived() {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserPubkey == null) throw UserMasterPubkeyNotFoundException();
    return [
      RequestFilter(
        kinds: const [IonConnectGiftWrapServiceImpl.kind],
        tags: {
          '#k': [WalletAssetEntity.kind.toString()],
          '#p': [currentUserPubkey],
        },
      ),
    ];
  }
}
