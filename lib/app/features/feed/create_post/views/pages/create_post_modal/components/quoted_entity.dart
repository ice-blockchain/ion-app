// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/components/quoted_post_frame/quoted_post_frame.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.c.dart';

class QuotedEntity extends ConsumerWidget {
  const QuotedEntity({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nostrEntity = ref.watch(nostrEntityProvider(eventReference: eventReference)).valueOrNull;

    if (nostrEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    if (nostrEntity is! PostEntity) {
      return Text('Quoting events ${nostrEntity.runtimeType} is not supported yet');
    }

    return Padding(
      padding: EdgeInsets.only(left: 40.0.s, top: 16.0.s),
      child: QuotedPostFrame(
        child: Post(
          eventReference: eventReference,
          header: UserInfo(pubkey: eventReference.pubkey),
          footer: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
