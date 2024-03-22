import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/story_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/story_list_skeleton.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/mock.dart';

class Stories extends HookConsumerWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> loading = useState(true);
    useEffect(
      () {
        Timer(const Duration(seconds: 3), () => loading.value = false);
        return null;
      },
      <Object?>[],
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0.s,
        top: 3.0.s,
      ),
      child: loading.value
          ? const StoryListSkeleton()
          : const StoryList(stories: stories),
    );
  }
}
