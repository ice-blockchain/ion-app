// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/poll/poll_answers_provider.c.dart';
import 'package:ion/app/features/core/providers/poll/poll_title_notifier.c.dart';
import 'package:ion/app/features/core/views/components/poll/poll.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_buttons.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/utils/validators.dart';

class ChatAddPollModal extends HookConsumerWidget {
  const ChatAddPollModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollTitle = ref.watch(pollTitleNotifierProvider);
    final pollAnswers = ref.watch(pollAnswersNotifierProvider);

    final isPoolValid = useMemoized(
      () => Validators.isPollValid(pollTitle.text, pollAnswers),
      [pollTitle.text, pollAnswers],
    );

    return SheetContent(
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
                padding: EdgeInsetsDirectional.only(top: 6.0.s),
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
                    enabled: isPoolValid,
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
