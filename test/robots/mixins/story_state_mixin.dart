// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';

import '../base_robot.dart';

mixin StoryStateMixin on BaseRobot {
  late final String viewerPubkey;
  late final ProviderContainer container;

  /// Initializes the story state mixin
  /// Stores viewerPubkey and ProviderContainer for state checking
  void initStoryState({
    required String pubkey,
    required ProviderContainer providerContainer,
  }) {
    viewerPubkey = pubkey;
    container = providerContainer;
  }

  void expectViewerState({
    required int userIndex,
    required int storyIndex,
  }) {
    _verifyViewerState(
      userIndex: userIndex,
      storyIndex: storyIndex,
    );
  }

  void _verifyViewerState({
    required int userIndex,
    required int storyIndex,
  }) {
    final state = container.read(storyViewingControllerProvider(viewerPubkey));

    expect(state.currentUserIndex, userIndex, reason: 'currentUserIndex');
    expect(state.currentStoryIndex, storyIndex, reason: 'currentStoryIndex');
  }
}
