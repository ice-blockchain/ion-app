// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_image.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

class ImageCarousel extends HookWidget {
  const ImageCarousel({
    required this.images,
    required this.initialIndex,
    required this.eventReference,
    super.key,
  });

  final List<MediaAttachment> images;
  final int initialIndex;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: initialIndex);

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return FullscreenImage(
                imageUrl: images[index].url,
                eventReference: eventReference,
              );
            },
          ),
        ),
        SizedBox(height: 20.0.s),
        ColoredBox(
          color: context.theme.appColors.primaryText,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
            child: SafeArea(
              top: false,
              child: CounterItemsFooter(
                eventReference: eventReference,
                color: context.theme.appColors.onPrimaryAccent,
                bottomPadding: 0,
                topPadding: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
