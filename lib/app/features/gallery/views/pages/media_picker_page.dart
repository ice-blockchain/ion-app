// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/scroll_view/load_more_builder.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/views/permission_aware_widget.dart';
import 'package:ice/app/features/gallery/data/models/gallery_state.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:ice/app/features/gallery/views/components/components.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class MediaPickerPage extends ConsumerWidget {
  const MediaPickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMedia = ref.watch(
      mediaSelectionNotifierProvider.select((state) => state.selectedMedia),
    );

    return PermissionAwareWidget(
      permissionType: AppPermissionType.photos,
      buildWithoutPermission: (_) => _buildContent(
        context,
        ref,
        selectedMedia,
        withShimmer: true,
      ),
      buildWithPermission: (_) => _buildContent(
        context,
        ref,
        selectedMedia,
      ),
      onPermissionGranted: () => ref.invalidate(galleryNotifierProvider),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> selectedMedia, {
    bool withShimmer = false,
  }) {
    final galleryState = ref.watch(galleryNotifierProvider);

    final slivers = [
      SliverAppBar(
        primary: false,
        flexibleSpace: NavigationAppBar.modal(
          title: Text(
            context.i18n.gallery_add_photo_title,
            style: context.theme.appTextThemes.subtitle,
          ),
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
        galleryState: withShimmer
            ? const GalleryState(
                mediaData: [],
                currentPage: 0,
                hasMore: true,
              )
            : galleryState.valueOrNull ??
                const GalleryState(
                  mediaData: [],
                  currentPage: 0,
                  hasMore: true,
                ),
        withShimmer: withShimmer,
      ),
    ];

    return SheetContent(
      body: LoadMoreBuilder(
        slivers: slivers,
        hasMore: !withShimmer && (galleryState.value?.hasMore ?? false),
        onLoadMore: () => ref.read(galleryNotifierProvider.notifier).fetchNextPage(),
        builder: (context, slivers) => CustomScrollView(slivers: slivers),
      ),
    );
  }
}
