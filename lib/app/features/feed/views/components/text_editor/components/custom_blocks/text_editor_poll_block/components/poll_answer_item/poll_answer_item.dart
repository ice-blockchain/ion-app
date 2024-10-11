// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/poll/poll_answers_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class PollAnswerItem extends HookConsumerWidget {
  const PollAnswerItem({required this.index, this.isLast = false, super.key});
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textThemes = context.theme.appTextThemes;

    final inputContainerKey = useRef(UniqueKey());

    final answer = ref.watch(pollAnswersNotifierProvider)[index];
    final textController = useTextEditingController(text: answer.text);

    useEffect(
      () {
        textController.text = answer.text;
        return null;
      },
      [answer.text],
    );

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            key: inputContainerKey.value,
            height: 36.0.s,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.onSecondaryBackground,
                borderRadius: BorderRadius.circular(12.0.s),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.s),
                child: TextField(
                  controller: textController,
                  onChanged: (value) =>
                      ref.read(pollAnswersNotifierProvider.notifier).updateAnswer(index, value),
                  style: textThemes.body2,
                  decoration: InputDecoration(
                    hintText: context.i18n.poll_choice_placeholder(index + 1),
                    hintStyle: textThemes.caption,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 10),
                  ),
                  cursorColor: colors.primaryAccent,
                  cursorHeight: 22.0.s,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.0.s),
        SizedBox(
          width: 20.0.s,
          height: 20.0.s,
          child: isLast
              ? GestureDetector(
                  onTap: () {
                    ref.read(pollAnswersNotifierProvider.notifier).removeAnswer(index);
                  },
                  child: Assets.svg.iconBlockDelete
                      .icon(size: 20.0.s, color: context.theme.appColors.quaternaryText),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
