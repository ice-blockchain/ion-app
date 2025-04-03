import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_image.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_state.c.dart';
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
    final onPrimaryAccentColor = context.theme.appColors.onPrimaryAccent;
    final horizontalPadding = 16.0.s;

    final isZoomed = ref.watch(imageZoomStateProvider);
    final currentPage = useState(initialIndex);
    final zoomInitialized = useState(false);
    final previousZoomState = usePrevious(isZoomed);

    useEffect(
      () {
        if ((previousZoomState ?? false) == true && isZoomed == false) {
          zoomInitialized.value = false;
        }

        return null;
      },
      [isZoomed, previousZoomState],
    );

    useEffect(
      () {
        zoomInitialized.value = false;
        return null;
      },
      [currentPage.value],
    );

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            physics:
                isZoomed || zoomInitialized.value ? const NeverScrollableScrollPhysics() : null,
            itemCount: images.length,
            onPageChanged: (index) => currentPage.value = index,
            itemBuilder: (context, index) {
              return FullscreenImage(
                imageUrl: images[index].url,
                onInteractionStarted: () => zoomInitialized.value = true,
                bottomOverlayBuilder: index == currentPage.value
                    ? (context) => SafeArea(
                          top: false,
                          child: ColoredBox(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                              child: CounterItemsFooter(
                                eventReference: eventReference,
                                color: onPrimaryAccentColor,
                                bottomPadding: 0,
                                topPadding: 0,
                              ),
                            ),
                          ),
                        )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
