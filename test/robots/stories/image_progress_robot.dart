// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_progress_controller.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';

import '../base_robot.dart';
import '../mixins/provider_scope_mixin.dart';

class _TestImageProgress extends HookConsumerWidget {
  const _TestImageProgress({
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
        final controller = result.imageController;
        if (controller != null) {
          onControllerReady(controller);
        }
        return null;
      },
      [result.imageController],
    );

    return const SizedBox.shrink();
  }
}

class ImageProgressRobot extends BaseRobot with ProviderScopeMixin {
  ImageProgressRobot(
    super.tester, {
    required this.post,
  });

  final ModifiablePostEntity post;

  late AnimationController _ctrl;
  bool _completed = false;
  bool _controllerReady = false;

  Finder get _finder => find.byType(_TestImageProgress);

  ProviderContainer get _container => getContainerFromFinder(_finder);

  Widget buildImageProgressWidget() => _TestImageProgress(
        post: post,
        onControllerReady: (c) {
          _ctrl = c;
          _controllerReady = true;
        },
        onCompleted: () => _completed = true,
      );

  Future<void> attach() async {
    await waitFor(() => tester.any(_finder) && _controllerReady);
  }

  void markImageLoaded() =>
      _container.read(storyImageLoadStatusProvider(post.id).notifier).markLoaded();

  set paused(bool value) => _container.read(storyPauseControllerProvider.notifier).paused = value;

  double get progress => _ctrl.value;

  void expectFrozen(double reference, {double tolerance = 0.001}) => expect(
        progress,
        closeTo(reference, tolerance),
        reason: 'progress should stay frozen while keyboard is open',
      );

  void expectCompleted() =>
      expect(_completed, isTrue, reason: 'onCompleted should fire exactly once');
}
