import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list_skeleton.dart';

class FeedAdvancedSearchTop extends HookWidget {
  const FeedAdvancedSearchTop({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    return CustomScrollView(slivers: [
      loading.value ? PostListSkeleton() : PostList(postIds: []),
    ]);
  }
}
