// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar_initial.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar_recording.dart';
import 'package:ion/app/features/chat/models/messaging_bottom_bar_state.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingBottomBar extends HookConsumerWidget {
  const MessagingBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messaingBottomBarActiveStateProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        AbsorbPointer(
          absorbing: bottomBarState.isVoice,
          child: const BottomBarInitialView(),
        ),
        if (bottomBarState.isVoice || bottomBarState.isVoiceLocked || bottomBarState.isVoicePaused)
          const BottomBarRecordingView(),
        const ActionButton(),
      ],
    );
  }
}

class ActionButton extends HookConsumerWidget {
  const ActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messaingBottomBarActiveStateProvider);
    final paddingBottom = useState<double>(0);

    Widget subButton() {
      switch (bottomBarState) {
        case MessagingBottomBarState.hasText:
        case MessagingBottomBarState.voicePaused:
          return SendButton(
            onSend: () {
              ref.read(messaingBottomBarActiveStateProvider.notifier).setText();
            },
          );
        case MessagingBottomBarState.voice:
        case MessagingBottomBarState.voiceLocked:
          return RecordVoiceButtonActive(paddingBottom: paddingBottom.value);
        case MessagingBottomBarState.text:
        case MessagingBottomBarState.more:
          return const RecordVoiceButton();
      }
    }

    return Positioned(
      bottom: 8.0.s,
      right: 14.0.s,
      child: GestureDetector(
        onLongPressStart: (details) {
          if (!bottomBarState.isVoice) {
            ref.read(messaingBottomBarActiveStateProvider.notifier).setVoice();
            HapticFeedback.lightImpact();
          }
        },
        onTap: () {
          if (bottomBarState.isVoice) {
            ref.read(messaingBottomBarActiveStateProvider.notifier).setText();
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
            ref.read(messaingBottomBarActiveStateProvider.notifier).setVoiceLocked();
            paddingBottom.value = 0;
          }
          // if (bottomBarState.isVoice) {
          //   ref.read(messaingBottomBarActiveStateProvider.notifier).setText();
          // }
        },
        child: AbsorbPointer(
          absorbing: bottomBarState.isVoiceLocked,
          child: subButton(),
        ),
      ),
    );
  }
}

class RecordVoiceButton extends HookConsumerWidget {
  const RecordVoiceButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
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

class RecordVoiceButtonActive extends HookConsumerWidget {
  const RecordVoiceButtonActive({required this.paddingBottom, super.key});

  final double paddingBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overlayEntry = useRef<OverlayEntry?>(null);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final overlay = Overlay.of(context);
          overlayEntry.value = OverlayEntry(
            builder: (context) {
              return ActiveRecordingOverlay(
                paddingBottom: paddingBottom,
              );
            },
          );
          overlay.insert(overlayEntry.value!);
        });
        return () {
          overlayEntry.value?.remove();
          overlayEntry.value = null;
        };
      },
      [paddingBottom],
    );

    return const SizedBox.shrink();
  }
}

class ActiveRecordingOverlay extends HookConsumerWidget {
  const ActiveRecordingOverlay({
    required this.paddingBottom,
    super.key,
  });

  final double paddingBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messaingBottomBarActiveStateProvider);

    final scale = paddingBottom < 20
        ? 1.0
        : paddingBottom > 60
            ? 1.2
            : 1.0 + ((paddingBottom - 20) / 80) * 0.2;

    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom + 8.0.s,
      right: 14.0.s,
      child: SafeArea(
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
        ),
        bottom: false,
        child: Container(
          width: 32.0.s,
          decoration: BoxDecoration(
            color: context.theme.appColors.onTerararyFill,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0.s),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (bottomBarState.isVoiceLocked)
                GestureDetector(
                  onTap: () {
                    ref.read(messaingBottomBarActiveStateProvider.notifier).setVoicePaused();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0.s),
                    child: Assets.svg.iconVideoPause.icon(
                      color: context.theme.appColors.primaryAccent,
                      size: 20.0.s,
                    ),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.only(top: 4.0.s),
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 100), // Quick animations for small steps
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: EdgeInsets.all(4.0.s),
                      decoration: BoxDecoration(
                        color: paddingBottom > 20
                            ? context.theme.appColors.primaryAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0.s),
                      ),
                      child: Assets.svg.linearSecurityLockKeyholeUnlocked.icon(
                        color: paddingBottom > 20
                            ? context.theme.appColors.onPrimaryAccent
                            : context.theme.appColors.primaryAccent,
                        size: 20.0.s,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 18.0.s),
              Container(
                padding: EdgeInsets.all(4.0.s),
                decoration: BoxDecoration(
                  color: context.theme.appColors.primaryAccent,
                  borderRadius: BorderRadius.circular(12.0.s),
                ),
                child: Assets.svg.iconChatMicrophone.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                  size: 24.0.s,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
