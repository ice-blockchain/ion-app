// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/media_content_handler.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';

class AdaptiveMediaView extends HookConsumerWidget {
  const AdaptiveMediaView({
    required this.eventReference,
    required this.initialMediaIndex,
    this.framedEventReference,
    super.key,
  });

  final EventReference eventReference;
  final EventReference? framedEventReference;
  final int initialMediaIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(ionConnectEntityProvider(eventReference: eventReference));

    return postAsync.maybeWhen(
      data: (post) {
        if (post is! ModifiablePostEntity) {
          return const SizedBox.shrink();
        }

        return MediaContentHandler(
          post: post,
          eventReference: eventReference,
          initialMediaIndex: initialMediaIndex,
          framedEventReference: framedEventReference,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
