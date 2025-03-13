// SPDX-License-Identifier: ice License 1.0

part of 'components.dart';

class PhotoGalleryCarousel extends HookWidget {
  const PhotoGalleryCarousel({
    required this.activeIndex,
    required this.photoUrls,
    super.key,
  });

  final ValueNotifier<int> activeIndex;
  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
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
      children: List.generate(photoUrls.length, (index) {
        return Hero(
          tag: photoUrls[index],
          child: Image.file(
            File(photoUrls[index]),
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }),
    );
  }
}
