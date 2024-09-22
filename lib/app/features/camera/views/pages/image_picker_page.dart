import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/camera/data/models/gallery_images_state.dart';
import 'package:ice/app/features/camera/providers/providers.dart';
import 'package:ice/app/features/camera/views/components/components.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class ImagePickerPage extends HookConsumerWidget {
  const ImagePickerPage({super.key});

  static final crossAxisCount = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    final onScroll = useCallback(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300) {
        ref.read(galleryImagesNotifierProvider.notifier).fetchNextPage();
      }
    }, [scrollController]);

    useEffect(() {
      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, onScroll]);

    final galleryImagesProvider = ref.watch(galleryImagesNotifierProvider);
    final selectedImages = ref.watch(
      imageSelectionNotifierProvider.select((state) => state.selectedImages),
    );

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(
              'Add photo',
              style: context.theme.appTextThemes.subtitle,
            ),
            showBackButton: true,
            actions: [
              AddImagesButton(
                onPressed: () => context.pop(selectedImages),
                imageCount: selectedImages.length.toString(),
              ),
            ],
          ),
          Expanded(
            child: GalleryGridview(
              galleryState: galleryImagesProvider.valueOrNull ??
                  GalleryImagesState(
                    images: [],
                    currentPage: 0,
                    hasMore: true,
                  ),
              isLoading: galleryImagesProvider.isLoading,
              scrollController: scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
