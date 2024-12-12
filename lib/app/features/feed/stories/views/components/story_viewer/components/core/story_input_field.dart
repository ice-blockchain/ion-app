// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';

class StoryInputField extends HookConsumerWidget {
  const StoryInputField({
    required this.controller,
    required this.bottomPadding,
    super.key,
  });

  final TextEditingController controller;
  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTextNotEmpty = useState(false);
    final focusNode = useFocusNode();

    useEffect(
      () {
        focusNode.addListener(
          () => focusNode.hasFocus
              ? ref.read(storyPauseControllerProvider.notifier).paused = true
              : ref.read(storyPauseControllerProvider.notifier).paused = false,
        );

        return null;
      },
      [],
    );

    useEffect(
      () {
        void onTextChanged() {
          isTextNotEmpty.value = controller.text.isNotEmpty;
        }

        controller.addListener(onTextChanged);

        return () {
          controller.removeListener(onTextChanged);
        };
      },
      [controller],
    );

    return Positioned(
      bottom: bottomPadding,
      left: 16.0.s,
      right: 68.0.s,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16.0.s,
              right: 16.0.s,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0.s),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 36.0.s,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Stack(
                    children: [
                      TextField(
                        minLines: 1,
                        maxLines: 4,
                        scrollPhysics: const BouncingScrollPhysics(),
                        cursorColor: context.theme.appColors.onPrimaryAccent,
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: context.theme.appColors.primaryText.withOpacity(0.5),
                          contentPadding: EdgeInsets.only(
                            left: 12.0.s,
                            top: 9.0.s,
                            bottom: 9.0.s,
                            right: 58.0.s,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0.s),
                            borderSide: BorderSide.none,
                          ),
                          hintText: context.i18n.write_a_message,
                          hintStyle: context.theme.appTextThemes.body2.copyWith(
                            color: context.theme.appColors.onPrimaryAccent,
                          ),
                          isDense: true,
                        ),
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: context.theme.appColors.onPrimaryAccent,
                        ),
                      ),
                      if (isTextNotEmpty.value)
                        Positioned(
                          bottom: 4.0.s,
                          right: 4.0.s,
                          child: ToolbarSendButton(
                            enabled: true,
                            onPressed: () {},
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
