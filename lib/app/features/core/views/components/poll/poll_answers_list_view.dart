// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/core/providers/poll/poll_answers_provider.c.dart';
import 'package:ion/app/features/core/views/components/poll/poll_answer_item.dart';

class PollAnswersListView extends ConsumerWidget {
  const PollAnswersListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(pollAnswersNotifierProvider);

    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10.0.s),
      itemCount: answers.length,
      itemBuilder: (context, index) {
        return PollAnswerItem(
          index: index,
          isLast: index != 0 && index == answers.length - 1,
        );
      },
    );
  }
}
