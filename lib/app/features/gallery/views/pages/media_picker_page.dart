import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/scroll_view/load_more_builder.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/gallery/data/models/gallery_media_state.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:ice/app/features/gallery/views/components/components.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class MediaPickerPage extends ConsumerWidget {
  const MediaPickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryState = ref.watch(galleryMediaNotifierProvider);
    final selectedMedia = ref.watch(
      mediaSelectionNotifierProvider.select((state) => state.selectedMedia),
    );

    final slivers = [
      SliverAppBar(
        primary: false,
        flexibleSpace: NavigationAppBar.modal(
          title: Text(
            context.i18n.gallery_add_photo_title,
            style: context.theme.appTextThemes.subtitle,
          ),
          showBackButton: true,
          actions: [
            AddImagesButton(
              onPressed: () => context.pop(selectedMedia),
              mediaCount: selectedMedia.length,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        pinned: true,
      ),
      GalleryGridview(
        galleryState: galleryState.valueOrNull ??
            GalleryMediaState(
              mediaData: [],
              currentPage: 0,
              hasMore: true,
            ),
      ),
    ];

    return SheetContent(
      body: LoadMoreBuilder(
        slivers: slivers,
        hasMore: galleryState.value?.hasMore ?? false,
        onLoadMore: () => ref.read(galleryMediaNotifierProvider.notifier).fetchNextPage(),
        builder: (context, slivers) => CustomScrollView(slivers: slivers),
      ),
    );
  }
}
