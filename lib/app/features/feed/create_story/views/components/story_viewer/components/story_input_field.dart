// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';

class StoryInputField extends HookWidget {
  const StoryInputField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isTextNotEmpty = useState(false);
    final focusNode = useFocusNode();

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 16.0.s,
            right: 16.0.s,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0.s),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: TextField(
                cursorColor: context.theme.appColors.onPrimaryAccent,
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.4),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.0.s,
                    vertical: 9.0.s,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0.s),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: isTextNotEmpty.value
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: 4.0.s,
                            bottom: 4.0.s,
                            right: 4.0.s,
                          ),
                          child: ToolbarSendButton(
                            enabled: true,
                            onPressed: () {},
                          ),
                        )
                      : null,
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
            ),
          ),
        ),
      ],
    );
  }
}
