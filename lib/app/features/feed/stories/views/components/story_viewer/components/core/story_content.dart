// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/can_reply_notifier.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_keyboard_height.dart';
import 'package:ion/app/features/feed/stories/providers/emoji_reaction_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_reply_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/story_viewer_header.dart';
import 'package:ion/app/utils/future.dart';

class StoryContent extends HookConsumerWidget {
  const StoryContent({
    required this.story,
    required this.viewerPubkey,
    super.key,
  });

  final ModifiablePostEntity story;
  final String viewerPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiState = ref.watch(emojiReactionsControllerProvider);
    final textController = useTextEditingController();
    final isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    final canReply = ref.watch(canReplyProvider(story.toEventReference())).valueOrNull ?? false;
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);
    final isOwnerStory = currentPubkey == story.masterPubkey;
    final borderRadius = 16.0.s;

    return Stack(
      fit: StackFit.expand,
      children: [
        Stack(
          fit: StackFit.expand,
          children: [
            Align(
              widthFactor: 1,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: isKeyboardVisible
                      ? BorderRadiusDirectional.only(
                          topStart: Radius.circular(borderRadius),
                          topEnd: Radius.circular(borderRadius),
                        )
                      : BorderRadius.circular(borderRadius),
                ),
                clipBehavior: Clip.hardEdge,
                child: StoryViewerContent(
                  post: story,
                  viewerPubkey: viewerPubkey,
                ),
              ),
            ),
          ],
        ),
        StoryViewerHeader(currentPost: story),
        _StoryControlsPanel(
          story: story,
          viewerPubkey: viewerPubkey,
          textController: textController,
          isKeyboardShown: isKeyboardVisible,
          canReply: canReply && !isOwnerStory,
        ),
        if (emojiState.showNotification && emojiState.selectedEmoji != null)
          StoryReactionNotification(emoji: emojiState.selectedEmoji!),
      ],
    );
  }
}

class _StoryControlsPanel extends HookConsumerWidget {
  const _StoryControlsPanel({
    required this.story,
    required this.viewerPubkey,
    required this.textController,
    required this.isKeyboardShown,
    required this.canReply,
  });

  final ModifiablePostEntity story;
  final String viewerPubkey;
  final TextEditingController textController;
  final bool isKeyboardShown;
  final bool canReply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelKey = useMemoized(GlobalKey.new);
    final controlsHeight = useState<double>(65.0.s);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box = panelKey.currentContext?.findRenderObject() as RenderBox?;
          if (box != null) controlsHeight.value = box.size.height;
        });
        return null;
      },
      const [],
    );

    final keyboardHeight = useKeyboardHeight();
    final safeArea = MediaQuery.viewPaddingOf(context).bottom;

    final baseline = safeArea + 16.0.s;
    final linear = keyboardHeight + safeArea - controlsHeight.value;
    final bottomPadding = math.max(baseline, linear);

    Future<void> onSubmit(String? txt) async {
      if (txt == null || txt.isEmpty) return;
      textController.clear();
      FocusScope.of(context).unfocus();
      unawaited(ref.read(storyReplyProvider.notifier).sendReply(story, replyText: txt));
    }

    ref.listen(
      storyReplyProvider,
      (_, next) => ref.read(storyPauseControllerProvider.notifier).paused = next.isLoading,
    );

    return Stack(
      children: [
        if (canReply)
          AnimatedPositionedDirectional(
            key: panelKey,
            duration: 50.ms,
            curve: Curves.easeOut,
            bottom: bottomPadding,
            start: 0.s,
            end: 52.0.s,
            child: StoryInputField(
              controller: textController,
              onSubmitted: onSubmit,
            ),
          ),
        AnimatedPositionedDirectional(
          duration: 50.ms,
          curve: Curves.easeOut,
          bottom: bottomPadding,
          end: 16.0.s,
          child: StoryViewerActionButtons(post: story),
        ),
        if (isKeyboardShown)
          StoryReactionOverlay(
            story: story,
            textController: textController,
          ),
      ],
    );
  }
}
