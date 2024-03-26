import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separated_column.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/features/feed/views/components/post_skeleton/post_skeleton.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/list_separator/list_separator.dart';

class PostListSkeleton extends StatelessWidget {
  const PostListSkeleton({
    super.key,
  });

  static const int numberOfItems = 3;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Skeleton(
        child: SeparatedColumn(
          separator: FeedListSeparator(),
          children: List<Widget>.generate(
            numberOfItems,
            (int i) => ScreenSideOffset.small(child: const PostSkeleton()),
          ).toList(),
        ),
      ),
    );
  }
}
