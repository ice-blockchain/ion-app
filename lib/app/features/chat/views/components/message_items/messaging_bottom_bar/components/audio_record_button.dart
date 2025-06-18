// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';
import 'package:ion/generated/assets.gen.dart';

class AudioRecordButton extends ConsumerWidget {
  const AudioRecordButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(4.0.s),
        child: IconAssetColored(
          Assets.svgIconChatMicrophone,
          color: context.theme.appColors.primaryText,
          size: 24,
        ),
      ),
    );
  }
}

class AudioRecordingButton extends HookConsumerWidget {
  const AudioRecordingButton({
    required this.paddingBottom,
    required this.onSubmitted,
    required this.onResumeRecording,
    super.key,
  });

  final double paddingBottom;
  final Future<void> Function() onSubmitted;
  final Future<void> Function() onResumeRecording;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overlayEntry = useRef<OverlayEntry?>(null);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final overlay = Overlay.of(context);
          overlayEntry.value = OverlayEntry(
            builder: (context) {
              return RecordingOverlay(
                paddingBottom: paddingBottom,
                onSubmitted: onSubmitted,
                onResumeRecording: onResumeRecording,
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
