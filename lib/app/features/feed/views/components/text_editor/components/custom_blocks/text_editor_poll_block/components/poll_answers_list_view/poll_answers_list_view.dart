// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/components/poll_answer_item/poll_answer_item.dart';

class PollAnswersListView extends StatelessWidget {
  const PollAnswersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10.0.s),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const PollAnswerItem();
      },
    );
  }
}
