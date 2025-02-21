// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_gradient_overlay.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_post_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class VideoOverlay extends StatelessWidget {
  const VideoOverlay({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Stack(
        children: [
          const Positioned.fill(
            child: VideoGradientOverlay(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VideoPostInfo(eventReference: eventReference),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.s,
                  vertical: 8.0.s,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      CounterItemsFooter(
                        eventReference: eventReference,
                        color: context.theme.appColors.onPrimaryAccent,
                        bottomPadding: 0,
                        topPadding: 0,
                      ),
                      ScreenBottomOffset(margin: 8.0.s),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
