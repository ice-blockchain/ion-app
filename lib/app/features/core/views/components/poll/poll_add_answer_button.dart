// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/poll/poll_answers_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class PollAddAnswerButton extends ConsumerWidget {
  const PollAddAnswerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(pollAnswersNotifierProvider);

    if (answers.length == 4) {
      return SizedBox(height: 10.0.s);
    }

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Button(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
        ),
        type: ButtonType.secondary,
        label: Text(
          context.i18n.poll_add_answer_button_title,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
        backgroundColor: context.theme.appColors.secondaryBackground,
        borderColor: context.theme.appColors.secondaryBackground,
        leadingIcon:
            Assets.svg.iconPostAddanswer.icon(color: context.theme.appColors.primaryAccent),
        leadingIconOffset: 0,
        onPressed: () {
          ref.read(pollAnswersNotifierProvider.notifier).addAnswer();
        },
      ),
    );
  }
}
