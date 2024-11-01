// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingBottomBar extends HookWidget {
  const MessagingBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    final hasText = useState(false);

    useEffect(
      () {
        void listener() {
          hasText.value = controller.text.isNotEmpty;
        }

        controller.addListener(listener);

        return () => controller.removeListener(listener);
      },
      [],
    );

    return Container(
      color: context.theme.appColors.onPrimaryAccent,
      padding: EdgeInsets.fromLTRB(8.0.s, 8.0.s, 14.0.s, 0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(4.0.s),
            child: Assets.svg.iconChatAttatch.icon(
              color: context.theme.appColors.primaryText,
              size: 24.0.s,
            ),
          ),
          SizedBox(width: 6.0.s),
          Expanded(
            child: TextField(
              controller: controller,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.primaryText,
              ),
              maxLines: null,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 7.0.s,
                  horizontal: 12.0.s,
                ),
                fillColor: context.theme.appColors.onSecondaryBackground,
                filled: true,
                hintText: 'Write a message...',
                hintStyle: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.quaternaryText,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0.s),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => controller.clear(),
            ),
          ),
          SizedBox(width: 6.0.s),
          Padding(
            padding: EdgeInsets.all(4.0.s),
            child: Assets.svg.iconCameraOpen.icon(
              color: context.theme.appColors.primaryText,
              size: 24.0.s,
            ),
          ),
          SizedBox(width: 6.0.s),
          AnimatedCrossFade(
            firstChild: GestureDetector(
              onTap: () {
                controller.clear();
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0.s, vertical: 4.0.s),
                decoration: BoxDecoration(
                  color: context.theme.appColors.primaryAccent,
                  borderRadius: BorderRadius.circular(12.0.s),
                ),
                child: Assets.svg.iconChatSendmessage.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                  size: 24.0.s,
                ),
              ),
            ),
            secondChild: Padding(
              padding: EdgeInsets.all(4.0.s),
              child: Assets.svg.iconChatMicrophone.icon(
                color: context.theme.appColors.primaryText,
                size: 24.0.s,
              ),
            ),
            crossFadeState: hasText.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
