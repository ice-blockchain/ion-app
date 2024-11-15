// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/article_data.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/data/models/repost_data.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repost_notifier.g.dart';

@riverpod
class RepostNotifier extends _$RepostNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> repost({
    required String eventId,
    required String pubkey,
    required int kind,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final data = switch (kind) {
        PostEntity.kind => RepostData(eventId: eventId, pubkey: pubkey),
        ArticleEntity.kind =>
          GenericRepostData(eventId: eventId, pubkey: pubkey, kind: ArticleEntity.kind),
        _ => throw UnsupportedRepostKindException(kind),
      };

      await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
    });
  }
}
