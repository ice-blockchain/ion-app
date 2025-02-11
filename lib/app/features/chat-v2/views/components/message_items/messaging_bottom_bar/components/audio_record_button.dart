// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat-v2/views/components/message_items/messaging_bottom_bar/components/components.dart';
import 'package:ion/generated/assets.gen.dart';

class AudioRecordButton extends ConsumerWidget {
  const AudioRecordButton({super.key});

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

class AudioRecordingButton extends HookConsumerWidget {
  const AudioRecordingButton({required this.paddingBottom, super.key});

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
              return RecordingOverlay(
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
