// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/polls/providers/poll_draft_provider.c.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarPollButton extends HookConsumerWidget {
  const ToolbarPollButton({
    this.focusNode,
    this.onPressed,
    this.enabled = true,
    super.key,
  });

  final FocusNode? focusNode;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPoll = ref.watch(pollDraftNotifierProvider).added;

    return ActionsToolbarButton(
      icon: Assets.svgIconPostPoll,
      enabled: !hasPoll && enabled,
      onPressed: () {
        ref.read(pollDraftNotifierProvider.notifier).markPollAdded();
      },
    );
  }
}
