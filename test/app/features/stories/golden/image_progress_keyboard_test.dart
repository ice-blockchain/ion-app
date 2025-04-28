// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_progress_controller.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';

import '../helpers/story_test_models.dart';
import '../helpers/story_test_utils.dart';

class _ImageProgressHost extends HookConsumerWidget {
  const _ImageProgressHost({
    required this.post,
    required this.onControllerReady,
    required this.onCompleted,
  });

  final ModifiablePostEntity post;
  final void Function(AnimationController) onControllerReady;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paused = ref.watch(storyPauseControllerProvider);

    final result = useStoryProgressController(
      ref: ref,
      post: post,
      isCurrent: true,
      isPaused: paused,
      onCompleted: onCompleted,
    );

    useEffect(
      () {
        if (result.imageController != null) {
          onControllerReady(result.imageController!);
        }
        return null;
      },
      [result.imageController],
    );

    return const SizedBox.shrink();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  registerStoriesFallbacks();

  group('Image progress & keyboard', () {
    testWidgets(
      'progress pauses on keyboard open and resumes after close',
      (tester) async {
        final post = buildPost('img_keyboard');
        var completedCalled = false;
        late AnimationController progressCtrl;

        await pumpWithOverrides(
          tester,
          child: _ImageProgressHost(
            post: post,
            onControllerReady: (c) => progressCtrl = c,
            onCompleted: () => completedCalled = true,
          ),
          overrides: storyViewerOverrides(post),
        );

        final container =
            ProviderScope.containerOf(tester.element(find.byType(_ImageProgressHost)));
        container.read(storyImageLoadStatusProvider(post.id).notifier).markLoaded();

        await tester.pump(const Duration(seconds: 2));

        container.read(storyPauseControllerProvider.notifier).paused = true;
        await tester.pump();
        final pausedValue = progressCtrl.value;

        await tester.pump(const Duration(seconds: 1));
        expect(
          progressCtrl.value,
          closeTo(pausedValue, 0.001),
          reason: 'progress should stay frozen while keyboard is open',
        );

        container.read(storyPauseControllerProvider.notifier).paused = false;
        await tester.pumpAndSettle(const Duration(seconds: 4));

        expect(
          completedCalled,
          isTrue,
          reason: 'onCompleted should fire exactly once after resume',
        );
      },
    );
  });
}
