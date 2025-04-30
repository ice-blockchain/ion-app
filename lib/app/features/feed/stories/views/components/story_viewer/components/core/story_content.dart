// SPDX-License-Identifier: ice License 1.0

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/can_reply_notifier.c.dart';
import 'package:ion/app/features/feed/stories/hooks/use_keyboard_height.dart';
import 'package:ion/app/features/feed/stories/providers/emoji_reaction_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_reply_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/story_header_gradient.dart';
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

    return ClipRRect(
      borderRadius: isKeyboardVisible
          ? BorderRadiusDirectional.only(
              topStart: Radius.circular(16.0.s),
              topEnd: Radius.circular(16.0.s),
            )
          : BorderRadius.circular(16.0.s),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              StoryViewerContent(
                post: story,
                viewerPubkey: viewerPubkey,
              ),
              if (ref.watch(storyReplyProvider).isLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Center(child: IONLoadingIndicator(size: Size.square(54.0.s))),
                ),
            ],
          ),
          Stack(
            children: [
              const StoryHeaderGradient(),
              StoryViewerHeader(currentPost: story),
            ],
          )
              .animate(target: _shouldShowUI(ref, isKeyboardVisible) ? 1 : 0)
              .fade(duration: 300.ms)
              .slideY(begin: -0.1, end: 0, duration: 300.ms),
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
      ),
    );
  }

  bool _shouldShowUI(WidgetRef ref, bool isKeyboardShown) {
    final paused = ref.watch(storyPauseControllerProvider);
    final loading = ref.watch(storyReplyProvider).isLoading;
    final menuOpen = ref.watch(storyMenuControllerProvider);
    return loading || !paused || menuOpen || isKeyboardShown;
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
      await ref.read(storyReplyProvider.notifier).sendReply(story, replyText: txt);
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
            start: 16.0.s,
            end: 68.0.s,
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
