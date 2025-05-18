// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';

import '../base_robot.dart';

mixin StoryStateMixin on BaseRobot {
  /// Verifies the current viewer state matches expected indices
  void expectViewerState({
    required int userIndex,
    required int storyIndex,
  }) {
    throw UnimplementedError('expectViewerState must be implemented by subclasses');
  }

  /// Internal method for actual state verification
  void verifyViewerState({
    required String viewerPubkey,
    required ProviderContainer container,
    required int userIndex,
    required int storyIndex,
  }) {
    final state = container.read(storyViewingControllerProvider(viewerPubkey));
    expect(state.currentUserIndex, userIndex, reason: 'currentUserIndex');
    expect(state.currentStoryIndex, storyIndex, reason: 'currentStoryIndex');
  }
}
