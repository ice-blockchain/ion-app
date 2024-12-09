// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/data/models/gallery_state.c.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/features/gallery/views/components/components.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

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
          title: Text(
            title ?? type.title(context),
            style: context.theme.appTextThemes.subtitle,
          ),
          onBackPress: () => Navigator.of(context).pop(),
          actions: [
            AddMediaButton(
              onPressed: () => Navigator.of(context).pop(selectedMedia),
              mediaCount: selectedMedia.length,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        pinned: true,
      ),
      GalleryGridView(
        type: type,
        galleryState: galleryState.valueOrNull ??
            GalleryState(
              mediaData: [],
              currentPage: 0,
              hasMore: true,
              type: type,
            ),
      ),
    ];

    final loadMoreBuilder = LoadMoreBuilder(
      slivers: slivers,
      hasMore: galleryState.value?.hasMore ?? false,
      onLoadMore: () => ref.read(galleryNotifierProvider(type: type).notifier).fetchNextPage(),
      builder: (context, slivers) => CustomScrollView(slivers: slivers),
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
