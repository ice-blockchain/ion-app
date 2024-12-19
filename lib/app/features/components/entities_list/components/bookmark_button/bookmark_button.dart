// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({required this.isBookmarked, required this.onBookmark, super.key});

  final bool isBookmarked;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: SvgPicture.asset(
        isBookmarked ? Assets.svg.iconBookmarksOn : Assets.svg.iconBookmarks,
      ),
      onPressed: onBookmark,
    );
  }
}
