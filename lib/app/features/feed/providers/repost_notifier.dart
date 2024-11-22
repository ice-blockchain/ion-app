// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repost_notifier.g.dart';

@riverpod
class RepostNotifier extends _$RepostNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> repost({
    required EventReference eventReference,
    required int kind,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final data = switch (kind) {
        PostEntity.kind =>
          RepostData(eventId: eventReference.eventId, pubkey: eventReference.pubkey),
        ArticleEntity.kind => GenericRepostData(
            eventId: eventReference.eventId,
            pubkey: eventReference.pubkey,
            kind: ArticleEntity.kind,
          ),
        _ => throw UnsupportedRepostKindException(kind),
      };

      await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
    });
  }
}
