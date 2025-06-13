// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'have_created_any_posts_provider.c.g.dart';

@riverpod
Future<bool> haveCreatedAnyPosts(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return false;
  }

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(
        kinds: const [ModifiablePostEntity.kind, PostEntity.kind, ArticleEntity.kind],
        authors: [currentPubkey],
        limit: 1,
      ),
    );
  final entity = await ref.read(ionConnectNotifierProvider.notifier).requestEntity(
        requestMessage,
      );

  return entity != null;
}
