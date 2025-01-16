// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/who_can_reply_settings_option.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'can_reply_provider.c.g.dart';

@riverpod
Future<bool> canReply(Ref ref, EventReference eventReference) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider).value;
  if (currentPubkey == null) return true;

  final ionConnectEntity = await ref.read(
    ionConnectEntityProvider(eventReference: eventReference).future,
  );
  if (ionConnectEntity == null) return true;

  final authorPubkey = ionConnectEntity.masterPubkey;
  if (authorPubkey == currentPubkey) return true;

  final whoCanReplySetting = switch (ionConnectEntity) {
    PostEntity() => ionConnectEntity.data.whoCanReplySetting,
    ArticleEntity() => ionConnectEntity.data.whoCanReplySetting,
    _ => null,
  };
  if (whoCanReplySetting == null) return true;

  switch (whoCanReplySetting) {
    case WhoCanReplySettingsOption.everyone:
      return true;
    case WhoCanReplySettingsOption.followedAccounts:
      final followers = await ref.watch(followListProvider(authorPubkey).future);
      if (followers == null) {
        return false;
      }
      return followers.data.list.any((followee) => followee.pubkey == currentPubkey);
    case WhoCanReplySettingsOption.mentionedAccounts:
      final mentions = switch (ionConnectEntity) {
        // TODO: Add support for mentions inside posts and articles
        _ => <RelatedPubkey>[],
      };
      if (mentions.isEmpty) {
        return false;
      }
      return mentions.any((pubKey) => pubKey.value == currentPubkey);
  }
}
