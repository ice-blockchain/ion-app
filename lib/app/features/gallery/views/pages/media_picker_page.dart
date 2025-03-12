// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/data/models/gallery_state.c.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/features/gallery/views/components/components.dart';
import 'package:ion/app/features/gallery/views/components/manage_access_banner.dart';
import 'package:ion/app/features/gallery/views/pages/album_selection_page.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class MediaPickerPage extends HookConsumerWidget {
  const MediaPickerPage({
    required this.maxSelection,
    this.type = MediaPickerType.common,
    this.title,
    this.isBottomSheet = false,
    super.key,
  });

  final int maxSelection;
  final MediaPickerType type;
  final String? title;
  final bool isBottomSheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryState = ref.watch(galleryNotifierProvider(type: type));
    final selectedMedia = ref.watch(
      mediaSelectionNotifierProvider.select((state) => state.selectedMedia),
    );

    final isAll = galleryState.valueOrNull?.selectedAlbum?.isAll ?? false;
    final albumName = galleryState.valueOrNull?.selectedAlbum?.name ?? type.title(context);

    ref.listen(mediaSelectionNotifierProvider, (_, value) {
      if (maxSelection == 1 && value.selectedMedia.isNotEmpty == true) {
        Navigator.of(context).pop(value.selectedMedia);
      }
    });

    useOnInit(
      () {
        ref.read(mediaSelectionNotifierProvider.notifier).updateMaxSelection(maxSelection);
      },
      [maxSelection],
    );

    final slivers = [
      SliverAppBar(
        primary: false,
        flexibleSpace: NavigationAppBar.modal(
          title: Button.dropdown(
            onPressed: () {
              showSimpleBottomSheet<List<MediaFile>>(
                context: context,
                child: AlbumSelectionPage(
                  type: type,
                  isBottomSheet: true,
                ),
              );
            },
            label: Text(
              isAll ? context.i18n.core_all : albumName,
              style: context.theme.appTextThemes.subtitle,
            ),
            trailingIconOffset: 2.0.s,
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
          ),
          onBackPress: () => Navigator.of(context).pop(),
          actions: [
            if (maxSelection > 1 && selectedMedia.isNotEmpty)
              AddMediaButton(
                onPressed: () => Navigator.of(context).pop(selectedMedia),
                mediaCount: selectedMedia.length,
              ),
          ],
        ),
        automaticallyImplyLeading: false,
        pinned: true,
      ),
      if (galleryState.valueOrNull?.limitedAccess ?? false)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.0.s),
            child: const ManageAccessBanner(),
          ),
        ),
      GalleryGridView(
        type: type,
        showSelectionBadge: maxSelection > 1,
        galleryState: galleryState.valueOrNull ??
            GalleryState(
              mediaData: [],
              currentPage: 0,
              hasMore: true,
              limitedAccess: false,
              type: type,
            ),
      ),
    ];

    final loadMoreBuilder = LoadMoreBuilder(
      slivers: slivers,
      hasMore: galleryState.value?.hasMore ?? false,
      onLoadMore: () => ref.read(galleryNotifierProvider(type: type).notifier).fetchNextPage(),
    );

    return isBottomSheet
        ? SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.9,
            child: loadMoreBuilder,
          )
        : SheetContent(
            body: loadMoreBuilder,
          );
  }
}
