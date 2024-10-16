// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/providers/poll/poll_answers_provider.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_answer_item.dart';

class PollAnswersListView extends ConsumerWidget {
  const PollAnswersListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(pollAnswersNotifierProvider);

    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10.0.s),
      itemCount: answers.length,
      itemBuilder: (context, index) {
        return PollAnswerItem(index: index, isLast: index != 0 && index == answers.length - 1);
      },
    );
  }
}
