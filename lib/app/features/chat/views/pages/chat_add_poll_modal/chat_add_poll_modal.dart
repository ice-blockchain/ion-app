// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/poll/poll_answers_provider.dart';
import 'package:ion/app/features/core/providers/poll/poll_title_notifier.dart';
import 'package:ion/app/features/core/views/components/poll/poll.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_buttons.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ChatAddPollModal extends ConsumerWidget {
  const ChatAddPollModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollTitle = ref.watch(pollTitleNotifierProvider);
    final pollAnswers = ref.watch(pollAnswersNotifierProvider);

    bool isPollValid() {
      return pollTitle.text.trim().isNotEmpty &&
          pollAnswers.length >= 2 &&
          pollAnswers.every(
            (answer) => answer.text.trim().isNotEmpty && answer.text.trim().length <= 25,
          );
    }

    return SheetContent(
      bottomPadding: 0,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.chat_add_poll_title),
            showBackButton: false,
            actions: [
              NavigationCloseButton(
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
          Expanded(
            child: ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(top: 6.0.s),
                child: const Poll(
                  autoFocusToQuestion: true,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const HorizontalSeparator(),
              ScreenSideOffset.small(
                child: ActionsToolbar(
                  actions: const [],
                  trailing: ToolbarSendButton(
                    enabled: isPollValid(),
                    onPressed: () {
                      //poll title -> ref.watch(pollTitleNotifierProvider)
                      //poll answers -> ref.watch(pollAnswersNotifierProvider)
                      context.pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
