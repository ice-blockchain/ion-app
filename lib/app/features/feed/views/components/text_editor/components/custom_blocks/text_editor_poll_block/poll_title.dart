// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/poll/poll_title_notifier.dart';

class PollTitle extends HookConsumerWidget {
  const PollTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textThemes = context.theme.appTextThemes;
    final title = ref.watch(pollTitleNotifierProvider).text;

    final textController = useTextEditingController(text: title);

    useEffect(
      () {
        if (textController.text != title) {
          textController.text = title;
        }
        return null;
      },
      [title],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 4.0.s),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          ref.read(pollTitleNotifierProvider.notifier).onTextChanged(value);
        },
        cursorColor: context.theme.appColors.primaryAccent,
        cursorHeight: 22.0.s,
        style: textThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: context.i18n.poll_title_placeholder,
          hintStyle: textThemes.body2.copyWith(
            color: context.theme.appColors.quaternaryText,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
