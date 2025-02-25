// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_image_reply_field.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class FullscreenImage extends StatelessWidget {
  const FullscreenImage({
    required this.imageUrl,
    required this.eventReference,
    super.key,
  });

  final String imageUrl;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CenteredLoadingIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        SizedBox(height: 20.0.s),
        ColoredBox(
          color: context.theme.appColors.primaryText,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CounterItemsFooter(
                  eventReference: eventReference,
                  color: context.theme.appColors.onPrimaryAccent,
                  bottomPadding: 0,
                  topPadding: 0,
                ),
                SizedBox(height: 11.0.s),
                const SafeArea(
                  top: false,
                  child: FullscreenImageReplyField(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
