// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/ion_connect_network_image/ion_connect_network_image.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.r.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/viewers/tap_to_see_hint.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.f.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/services/logger/logger.dart';

class ImageStoryViewer extends ConsumerWidget {
  const ImageStoryViewer({
    required this.imageUrl,
    required this.authorPubkey,
    required this.storyId,
    this.quotedEvent,
    this.richTextContent,
    super.key,
  });

  final String imageUrl;
  final String authorPubkey;
  final String storyId;
  final QuotedEvent? quotedEvent;
  final String? richTextContent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheManager = ref.watch(storyImageCacheManagerProvider);

    // Extract source post reference from richText if present
    EventReference? sourcePostReference;
    if (richTextContent != null && quotedEvent == null) {
      try {
        final delta = Delta.fromJson(jsonDecode(richTextContent!) as List<dynamic>);
        for (final op in delta.operations) {
          final attrs = op.attributes;
          if (attrs != null && attrs.containsKey('sourcePost')) {
            sourcePostReference = EventReference.fromEncoded(attrs['sourcePost'] as String);
            break;
          }
        }
      } catch (_) {
        Logger.error('Failed to parse rich text content for source post reference');
      }
    }

    final hasQuotedPost = quotedEvent != null || sourcePostReference != null;

    final imageWidget = IonConnectNetworkImage(
      imageUrl: imageUrl,
      authorPubkey: authorPubkey,
      cacheManager: cacheManager,
      filterQuality: FilterQuality.high,
      placeholder: (_, __) => const CenteredLoadingIndicator(),
      imageBuilder: (context, imageProvider) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(storyImageLoadStatusProvider(storyId).notifier).markLoaded();
          }
        });

        return SizedBox.expand(
          child: Image(
            image: imageProvider,
            fit: hasQuotedPost ? BoxFit.contain : BoxFit.cover,
          ),
        );
      },
    );

    if (hasQuotedPost) {
      return ColoredBox(
        color: context.theme.appColors.attentionBlock,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.s),
          child: FractionallySizedBox(
            heightFactor: 0.7,
            child: TapToSeeHint(
              onTap: () {
                // Get event reference from either quotedEvent or sourcePostReference
                final eventReference = quotedEvent?.eventReference ?? sourcePostReference!;
                PostDetailsRoute(
                  eventReference: eventReference.encode(),
                ).push<void>(context);
              },
              onVisibilityChanged: (isVisible) {
                ref.read(storyPauseControllerProvider.notifier).paused = isVisible;
              },
              child: imageWidget,
            ),
          ),
        ),
      );
    }

    return imageWidget;
  }
}
