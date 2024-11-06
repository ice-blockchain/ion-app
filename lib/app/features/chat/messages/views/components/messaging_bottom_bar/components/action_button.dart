// SPDX-License-Identifier: ice License 1.0

part of '../messaging_bottom_bar.dart';

class _ActionButton extends HookConsumerWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);
    final paddingBottom = useState<double>(0);

    Widget subButton() {
      switch (bottomBarState) {
        case MessagingBottomBarState.hasText:
        case MessagingBottomBarState.voicePaused:
          return _SendButton(
            onSend: () {
              ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
            },
          );
        case MessagingBottomBarState.voice:
        case MessagingBottomBarState.voiceLocked:
          return AudioRecordingButton(paddingBottom: paddingBottom.value);
        case MessagingBottomBarState.text:
        case MessagingBottomBarState.more:
          return const _AudioRecordButton();
      }
    }

    return Positioned(
      bottom: 8.0.s + (bottomBarState.isMore ? moreContentHeight : 0),
      right: 14.0.s,
      child: GestureDetector(
        onLongPressStart: (details) {
          if (!bottomBarState.isVoice) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setVoice();
            HapticFeedback.lightImpact();
          }
        },
        onTap: () {
          if (bottomBarState.isVoice) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
          }
        },
        onLongPressMoveUpdate: (details) {
          if (details.localOffsetFromOrigin.dy < 0) {
            paddingBottom.value = details.localOffsetFromOrigin.dy * -1;
          } else {
            paddingBottom.value = 0;
          }
        },
        onLongPressEnd: (details) {
          if (paddingBottom.value > 20) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setVoiceLocked();
            paddingBottom.value = 0;
          }
        },
        child: AbsorbPointer(
          absorbing: bottomBarState.isVoiceLocked,
          child: subButton(),
        ),
      ),
    );
  }
}
