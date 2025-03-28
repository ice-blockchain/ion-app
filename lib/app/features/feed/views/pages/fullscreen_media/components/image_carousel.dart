// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_image.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

class ImageCarousel extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(initialPage: initialIndex);
    final primaryTextColor = context.theme.appColors.primaryText;
    final onPrimaryAccentColor = context.theme.appColors.onPrimaryAccent;
    final sizedBoxHeight = 20.0.s;
    final horizontalPadding = 16.0.s;
    // final isZoomed = ref.watch(isImageZoomedProvider);

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: images.length,
            // physics:
            //     isZoomed ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return FullscreenImage(
                imageUrl: images[index].url,
                eventReference: eventReference,
              );
            },
          ),
        ),
        SizedBox(height: sizedBoxHeight),
        ColoredBox(
          color: primaryTextColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: SafeArea(
              top: false,
              child: CounterItemsFooter(
                eventReference: eventReference,
                color: onPrimaryAccentColor,
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
