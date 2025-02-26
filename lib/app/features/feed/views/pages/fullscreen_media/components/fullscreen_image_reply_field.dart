// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';

class FullscreenImageReplyField extends HookConsumerWidget {
  const FullscreenImageReplyField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final isTextNotEmpty = useState(false);

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Stack(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: context.theme.appColors.primaryText.withValues(alpha: 0.5),
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
                hintText: context.i18n.post_reply_hint,
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
                  onPressed: controller.clear,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
