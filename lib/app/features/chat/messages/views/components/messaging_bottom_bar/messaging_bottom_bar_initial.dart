// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class BottomBarInitialView extends HookConsumerWidget {
  const BottomBarInitialView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      constraints: BoxConstraints(
        minHeight: 48.0.s,
      ),
      padding: EdgeInsets.fromLTRB(8.0.s, 8.0.s, 14.0.s, 8.0.s),
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
          if (hasText.value)
            SendButton(
              onSend: () {
                ref.read(messaingBottomBarActiveStateProvider.notifier).setText();
                controller.clear();
              },
            )
          else
            const RecordVoiceButton(),
        ],
      ),
    );
  }
}

class RecordVoiceButton extends ConsumerWidget {
  const RecordVoiceButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () {
        ref.read(messaingBottomBarActiveStateProvider.notifier).setVoice();
        HapticFeedback.lightImpact();
      },
      child: Padding(
        padding: EdgeInsets.all(4.0.s),
        child: Assets.svg.iconChatMicrophone.icon(
          color: context.theme.appColors.primaryText,
          size: 24.0.s,
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  const SendButton({
    required this.onSend,
    super.key,
  });

  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
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
    );
  }
}
