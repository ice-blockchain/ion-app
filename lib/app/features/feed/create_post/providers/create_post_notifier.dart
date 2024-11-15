// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_notifier.g.dart';

@riverpod
class CreatePostNotifier extends _$CreatePostNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> create({
    required String content,
    NostrEntity? parentEntity,
    QuotedEvent? quotedEvent,
    List<MediaFile>? media,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      //TODO:: upload media and add to event's mediaAttachment
      final data = PostData.fromRawContent(content).copyWith(quotedEvent: quotedEvent);
      await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
    });
  }
}
