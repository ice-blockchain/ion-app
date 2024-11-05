// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class BottomBarRecordingView extends HookConsumerWidget {
  const BottomBarRecordingView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = useRef(
      RecorderController(),
    );

    final duration = useState('00:00');

    void showOverlay(BuildContext context) {
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder: (context) {
          return VoiceRecordingActiveButton(
            onPaused: () {
              recorderController.value.pause();
            },
          );
        },
      );
      overlay.insert(overlayEntry);
    }

    useEffect(
      () {
        recorderController.value.record();
        recorderController.value.onCurrentDuration.listen((event) {
          duration.value = formatDuration(event);
        });
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showOverlay(context);
        });
        return () {
          recorderController.value.dispose();
        };
      },
      [],
    );

    return Container(
      color: context.theme.appColors.onPrimaryAccent,
      padding: EdgeInsets.fromLTRB(16.0.s, 0, 16.0.s, 0.0.s),
      constraints: BoxConstraints(
        minHeight: 48.0.s,
      ),
      width: double.infinity,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              recorderController.value.stop();
              ref.read(messaingBottomBarActiveStateProvider.notifier).setText();
            },
            child: Text(
              'Cancel',
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.primaryAccent,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 4.0.s,
            height: 4.0.s,
            decoration: BoxDecoration(
              color: context.theme.appColors.attentionRed,
              borderRadius: BorderRadius.circular(12.0.s),
            ),
          ),
          SizedBox(width: 4.0.s),
          Text(
            duration.value,
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
          SizedBox(width: 48.0.s),
        ],
      ),
    );
  }
}

class VoiceRecordingActiveButton extends HookConsumerWidget {
  const VoiceRecordingActiveButton({
    required this.onPaused,
    super.key,
  });

  final VoidCallback onPaused;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messaingBottomBarActiveStateProvider);
    final isLocked = useState(false);

    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom + 8.0.s,
      right: 16.0.s,
      child: GestureDetector(
        onLongPress: () {
          print('long press');
        },
        child: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
          ),
          bottom: false,
          child: Container(
            height: bottomBarState.isVoice ? 78.0.s : 0,
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
                //lock button
                GestureDetector(
                  onTap: () {
                    if (isLocked.value) {
                      onPaused();
                    }
                    isLocked.value = !isLocked.value;
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AbsorbPointer(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0.s),
                      child: isLocked.value
                          ? Assets.svg.iconVideoPause.icon(
                              color: context.theme.appColors.primaryAccent,
                              size: 20.0.s,
                            )
                          : Assets.svg.linearSecurityLockKeyholeUnlocked.icon(
                              color: context.theme.appColors.primaryAccent,
                              size: 20.0.s,
                            ),
                    ),
                  ),
                ),
                // record button
                GestureDetector(
                  onTap: () {
                    ref.read(messaingBottomBarActiveStateProvider.notifier).setText();
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
