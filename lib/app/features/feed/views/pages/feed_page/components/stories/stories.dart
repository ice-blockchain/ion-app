// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_skeleton.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class Stories extends HookConsumerWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(true);
    useOnInit(
      () {
        Timer(const Duration(seconds: 3), () => loading.value = false);
      },
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0.s,
        top: 3.0.s,
      ),
      child: loading.value ? const StoryListSkeleton() : StoryList(stories: stories),
    );
  }
}
