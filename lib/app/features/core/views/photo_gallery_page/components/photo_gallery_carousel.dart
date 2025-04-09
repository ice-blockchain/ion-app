// SPDX-License-Identifier: ice License 1.0

part of 'components.dart';

class PhotoGalleryCarousel extends HookConsumerWidget {
  const PhotoGalleryCarousel({
    required this.activeIndex,
    required this.medias,
    required this.entity,
    super.key,
  });

  final ValueNotifier<int> activeIndex;
  final List<MessageMediaTableData> medias;
  final PrivateDirectMessageData entity;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useRef(CarouselController());

    useEffect(
      () {
        controller.value.addListener(() {
          final offset = controller.value.offset;
          final screenWidth = MediaQuery.sizeOf(context).width;
          final index = (offset / screenWidth).round();
          activeIndex.value = index + 1;
        });

        return controller.value.dispose;
      },
      [],
    );

    return CarouselView(
      controller: controller.value,
      itemExtent: double.infinity,
      backgroundColor: context.theme.appColors.primaryText,
      shape: const RoundedRectangleBorder(),
      padding: EdgeInsets.zero,
      children: List.generate(medias.length, (index) {
        final media = medias[index];

        final mediaAttachment = media.remoteUrl == null ? null : entity.media[media.remoteUrl!];

        final fileFuture = ref.read(
          chatMessageLoadMediaProvider(
            entity: entity,
            mediaAttachment: mediaAttachment,
            cacheKey: media.cacheKey,
            loadThumbnail: false,
          ),
        );

        return FutureBuilder(
          future: fileFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            final isImage =
                MediaType.fromMimeType(mediaAttachment?.mimeType ?? '') == MediaType.image;
            if (isImage) {
              return Image.file(
                snapshot.data!,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              );
            }
            return VideoPreview(videoUrl: snapshot.data!.path);
          },
        );
      }),
    );
  }
}
