// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/model/event_setting.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'can_reply_provider.c.g.dart';

@riverpod
Future<bool> canReply(Ref ref, EventReference eventReference) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) return true;

  final nostrEntity = await ref.read(
    nostrEntityProvider(eventReference: eventReference).future,
  );
  if (nostrEntity == null) return true;

  final authorPubkey = nostrEntity.masterPubkey;
  if (authorPubkey == currentPubkey) return true;

  final settings = switch (nostrEntity) {
    PostEntity() => nostrEntity.data.settings,
    ArticleEntity() => nostrEntity.data.settings,
    _ => null,
  };
  if (settings == null || settings.isEmpty) return true;

  final whoCanReplySettings =
      settings.firstWhereOrNull((setting) => setting is WhoCanReplyEventSetting)
          as WhoCanReplyEventSetting?;
  if (whoCanReplySettings == null) return true;

  var canReply = true;
  for (final setting in whoCanReplySettings.values) {
    switch (setting) {
      case WhoCanReplySettingsOption.everyone:
      case WhoCanReplySettingsOption.verifiedAccounts:
        // TODO: Add logic for verified accounts
        canReply = true;
      case WhoCanReplySettingsOption.followedAccounts:
        final followers = await ref.watch(followListProvider(authorPubkey).future);
        if (followers == null) {
          canReply = false;
          break;
        }
        canReply = followers.data.list.any((followee) => followee.pubkey == currentPubkey);
      case WhoCanReplySettingsOption.mentionedAccounts:
        final mentions = switch (nostrEntity) {
          PostEntity() => nostrEntity.data.relatedPubkeys,
          // TODO: Add support for mentions inside articles
          _ => null,
        };
        if (mentions == null || mentions.isEmpty) {
          canReply = false;
          break;
        }
        canReply = mentions.any((pubKey) => pubKey.value == currentPubkey);
    }
    if (!canReply) break;
  }

  return canReply;
}
